import os
import logging
from google import genai
from google.genai import types
from . import config # Import config from the app package

def process_receipt(image_path, purchase_name, expected_cost, user_justification):
    """
    Analyzes receipt image and justification, evaluates prudence, verifies amount.
    Returns deduction points and reason.
    """
    uploaded_file = None
    client = None
    try:
        api_key = config.ANALYSIS_API_KEY # Get key from config module
        if not api_key:
             logging.error("Analysis API Key not found.")
             return None, "Error: Analysis API Key is missing."

        client = genai.Client(api_key=api_key)
        logging.info(f"Uploading file for analysis: {image_path}")
        uploaded_file = client.files.upload(file=image_path)
        logging.info(f"File uploaded: URI={uploaded_file.uri}, Name={uploaded_file.name}")

        model_name = "gemini-1.5-flash" # Specify model
        logging.info(f"Using analysis model: {model_name}")

        # Task definition for the analysis model
        contents = [
            types.Content( role="user", parts=[
                    types.Part.from_uri(file_uri=uploaded_file.uri, mime_type=uploaded_file.mime_type),
                    types.Part.from_text( text=( f"Analyze this receipt for a purchase named '{purchase_name}'. "
                            f"The expected total cost is ${expected_cost:.2f}. "
                            f"User justification: \"{user_justification}\". "
                            "Evaluate the receipt image and the user's justification for prudence." ) ) ] ),
            types.Content( role="model", parts=[
                    types.Part.from_text( text=(
                            "Okay, I will analyze the receipt and justification for financial prudence. "
                            "1. Extract the final total amount. "
                            "2. Compare extracted total to expected (${expected_cost:.2f}, within $1.00). Prioritize reporting mismatches. "
                            "3. Evaluate necessity/frivolousness based on item ('{purchase_name}'), cost (${expected_cost:.2f}), and justification ('{user_justification}'). "
                            "4. Determine deduction (0-100). Necessary/well-justified = low/0. Luxury/unnecessary/frivolous = higher points, even if justification explains a non-essential purchase. Questionable/weak justification = very high points. If amounts mismatch significantly, deduction should be 0. "
                            "IMPORTANT: Respond *ONLY* with 3 lines:\n"
                            "[deduction integer <= 100]\n"
                            "[extracted_total or N/A]\n"
                            "[one-line reason (necessity/frivolousness/mismatch)]" ) ) ] ), ]

        generate_content_config = types.GenerateContentConfig( response_mime_type="text/plain", temperature=0.2 )

        logging.info(f"Sending request to analysis model: {model_name} with justification & prudence check.")
        response = client.models.generate_content(model=model_name, contents=contents, config=generate_content_config)
        response_text = response.text.strip()
        logging.info(f"Analysis Response:\n{response_text}")

        if uploaded_file and uploaded_file.name:
            logging.info(f"Deleting uploaded file: {uploaded_file.name}")
            try:
                client.files.delete(name=uploaded_file.name)
                uploaded_file = None
            except Exception as del_e:
                logging.warning(f"Delete failed {uploaded_file.name}: {del_e}")

        all_lines = [line.strip() for line in response_text.splitlines() if line.strip()]
        found_lines = None
        if len(all_lines) >= 3:
            for i in range(len(all_lines) - 3, -1, -1):
                pdl = all_lines[i].replace('`','').replace('[','').replace(']','').strip()
                pal = all_lines[i+1].replace('`','').replace('$','').replace('[','').replace(']','').strip()
                prl = all_lines[i+2].strip()
                is_int = False
                try:
                    int(pdl)
                    is_int = True
                except ValueError: pass
                is_amt = False
                if pal.upper() == 'N/A': is_amt = True
                elif pal:
                    try:
                        float(pal)
                        is_amt = True
                    except ValueError: pass
                if is_int and is_amt:
                    found_lines = [pdl, pal, prl]
                    logging.info(f"Parsed result lines at {i}: {found_lines}")
                    break

        if not found_lines:
             if len(all_lines) >= 3:
                 logging.warning("Robust search failed, fallback last 3.")
                 l1 = all_lines[-3].replace('`','').replace('[','').replace(']','').strip()
                 l2 = all_lines[-2].replace('`','').replace('$','').replace('[','').replace(']','').strip()
                 l3 = all_lines[-1].strip()
                 try:
                     int(l1)
                     if l2.upper() != 'N/A': float(l2)
                     found_lines = [l1, l2, l3]
                     logging.info(f"Fallback lines: {found_lines}")
                 except ValueError:
                     logging.error("Fallback failed.")
                     return None,"Error: Analysis format incorrect (Fallback fail)."
             else:
                 logging.error(f"Not enough lines from analysis: {all_lines}")
                 return None,"Error: Analysis format incorrect (Too few lines)."

        try:
            lines = found_lines
            deduction = int(lines[0])
            ets = lines[1]
            analysis_reason = lines[2]

            if ets.upper() == 'N/A':
                logging.warning("Analysis couldn't extract total.")
                deduction = max(0, min(100, deduction))
                reason = f"Total N/A; Analysis Reason: {analysis_reason}"
                logging.info(f"OK (Total N/A). Deduct:{deduction}, Reason:{reason}")
                return deduction, reason

            try:
                extracted_total = float(ets)
            except ValueError:
                logging.error(f"Non-numeric total '{ets}' from analysis.")
                return None, f"Error: Analysis provided non-numeric total ('{ets}'). Reason: {analysis_reason}"

            if abs(extracted_total - expected_cost) > 1.00:
                mismatch_reason = f"Error: Receipt total (${extracted_total:.2f}) doesn't match expected (${expected_cost:.2f})."
                logging.warning(mismatch_reason)
                if not any(w in analysis_reason.lower() for w in ["mismatch", "match", "amount", "total", "different", "cost", "price", "$"]):
                     return None, mismatch_reason
                else:
                    logging.info(f"Amount mismatch, but analysis reason '{analysis_reason}' seems relevant. Failing justification.")
                    return None, analysis_reason

            deduction = max(0, min(100, deduction))
            logging.info(f"OK. Deduct:{deduction}, Reason:{analysis_reason}")
            return deduction, analysis_reason

        except (ValueError, IndexError) as e:
            logging.error(f"Parse error:{e}\nLines:{lines}")
            return None, "Error: Could not parse analysis response."

    except genai.types.generation_types.StopCandidateException as stop_e:
        logging.error(f"Analysis content generation stopped unexpectedly: {stop_e}")
        try: logging.error(f"Stopping Candidate: {stop_e.candidate}")
        except AttributeError: pass
        if client and uploaded_file and uploaded_file.name:
            try: client.files.delete(name=uploaded_file.name)
            except Exception as del_e: logging.warning(f"Cleanup fail: {del_e}")
        return None, f"Error: Analysis processing stopped (content policy or limit)."

    except Exception as e:
        logging.exception(f"Analysis processing error: {e}")
        if client and uploaded_file and uploaded_file.name:
            try:
                logging.warning(f"Cleanup {uploaded_file.name}")
                client.files.delete(name=uploaded_file.name)
            except Exception as del_e:
                logging.warning(f"Cleanup fail: {del_e}")
        return None, f"Error during receipt analysis: {e}"