import os
import logging
from flask import (request, render_template, redirect, url_for,
                   flash, send_from_directory, session, current_app)
from werkzeug.utils import secure_filename

from . import app  # Import the app instance
from . import config # Import config settings
from .auth import login_required # Import the decorator
from .processing import process_receipt # Import the processing function
# Import data and save function from data_management
from .data_management import purchase_data, save_data, load_data


@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        password = request.form.get('password')

        if username in config.ALLOWED_USERNAMES and password == config.CONCEPT_PASSWORD:
            session['username'] = username
            flash(f"Login successful! Welcome, {username}.", "success")
            next_url = request.args.get('next')
            return redirect(next_url or url_for('dashboard'))
        else:
            flash("Invalid username or password.", "error")
            return render_template('login.html.html')

    if 'username' in session and session['username'] in config.ALLOWED_USERNAMES:
        return redirect(url_for('dashboard'))

    return render_template('login.html.html')


@app.route('/logout')
def logout():
    session.pop('username', None)
    flash("You have been logged out.", "success")
    return redirect(url_for('login'))


@app.route('/dashboard')
@login_required
def dashboard():
    customer = session['username']
    view = request.args.get('view') # Get view arg

    customer_record = purchase_data.get(customer, {"pending": [], "justified": [], "points": 1000})
    pending = customer_record.get("pending", [])
    history = customer_record.get("justified", [])
    points = customer_record.get("points", 1000)

    # If no view specified, determine default
    if view is None:
        default_view = 'pending' if pending else 'history'
        return redirect(url_for('dashboard', view=default_view))

    return render_template('dashboard.html',
                           customer=customer, view=view, pending=pending, pending_count=len(pending),
                           history=history, history_count=len(history), points=points,
                           purchase_data=purchase_data) # Pass purchase_data for the nav check


@app.route('/justify', methods=['POST'])
@login_required
def justify():
    customer = session['username']
    purchase_index_str = request.form.get('purchase_index')
    file = request.files.get('receipt')
    user_justification = request.form.get('justification', '').strip()

    if not purchase_index_str or not purchase_index_str.isdigit():
        flash("Invalid purchase index.", "error")
        return redirect(url_for('dashboard', view='pending'))

    purchase_index = int(purchase_index_str)
    # Ensure data is up-to-date for the specific user
    customer_record = purchase_data.setdefault(customer, {"pending": [], "justified": [], "points": 1000})
    pending = customer_record.get("pending", [])

    if not (0 <= purchase_index < len(pending)):
        flash("Purchase index out of range.", "error")
        return redirect(url_for('dashboard', view='pending'))
    if not file or file.filename == '':
        flash("No receipt file selected.", "error")
        return redirect(url_for('dashboard', view='pending'))
    if not user_justification:
        flash("Please provide a justification.", "error")
        return redirect(url_for('dashboard', view='pending'))

    local_file_path = None
    try:
        purchase_to_justify = pending[purchase_index]
        purchase_name = purchase_to_justify.get('description', 'N/A')
        try:
            cost = float(purchase_to_justify.get('amount', 0.0))
        except (ValueError, TypeError):
             logging.error(f"Invalid purchase amount for {customer}: {purchase_to_justify}")
             flash("Invalid purchase amount recorded.", "error")
             return redirect(url_for('dashboard', view='pending'))

        purchase_id = purchase_to_justify.get('_id', f'idx_{purchase_index}')
        extension = os.path.splitext(file.filename)[1].lower()
        allowed_extensions = {'.png', '.jpg', '.jpeg', '.gif', '.webp', '.bmp', '.pdf'}
        if extension not in allowed_extensions:
            flash(f"Invalid file type ({extension}). Allowed: {', '.join(allowed_extensions)}", "error")
            return redirect(url_for('dashboard', view='pending'))

        filename = secure_filename(f"{customer.replace(' ','_')}_{purchase_id}{extension or '.bin'}")
        local_file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
        file.save(local_file_path)
        logging.info(f"Saved receipt for {customer}: {local_file_path}")

        deduction, message = process_receipt(local_file_path, purchase_name, cost, user_justification)

        if deduction is None:
            flash(f"Processing Failed: {message}", "error")
            if local_file_path and os.path.exists(local_file_path):
                try:
                    os.remove(local_file_path)
                    logging.info(f"Removed unprocessed receipt: {local_file_path}")
                except OSError as e:
                    logging.warning(f"Failed to remove unprocessed receipt {local_file_path}: {e}")
            return redirect(url_for('dashboard', view='pending'))
        else:
            purchase = pending.pop(purchase_index)
            current_points = customer_record.get("points", 1000)
            customer_record["points"] = max(current_points - deduction, 0)
            justified_record = {
                "purchase": purchase,
                "deduction": deduction,
                "analysis_reason": message, # Renamed from ai_reason
                "receipt_filename": filename,
                "justification": user_justification
            }
            customer_record.setdefault("justified", []).append(justified_record)
            save_data(purchase_data)
            flash(f"'{purchase_name}' submitted! Points deducted: {deduction}.", "success")
            return redirect(url_for('dashboard', view='pending'))

    except Exception as e:
        logging.exception(f"Error in /justify for {customer}: {e}")
        flash(f"An unexpected error occurred during justification: {e}", "error")
        if local_file_path and os.path.exists(local_file_path):
             try:
                 os.remove(local_file_path)
                 logging.info(f"Removed file after justification exception: {local_file_path}")
             except OSError as del_e:
                 logging.warning(f"Failed to remove file after justification exception: {del_e}")
        return redirect(url_for('dashboard', view='pending'))


@app.route('/penalize', methods=['POST'])
@login_required
def penalize():
    customer = session['username']
    purchase_index_str = request.form.get('purchase_index')

    if not purchase_index_str or not purchase_index_str.isdigit():
        flash("Invalid purchase index.", "error")
        return redirect(url_for('dashboard', view='pending'))

    purchase_index = int(purchase_index_str)
    customer_record = purchase_data.setdefault(customer, {"pending": [], "justified": [], "points": 1000})
    pending = customer_record.get("pending", [])

    if not (0 <= purchase_index < len(pending)):
        flash("Purchase index out of range.", "error")
        return redirect(url_for('dashboard', view='pending'))

    try:
        purchase = pending.pop(purchase_index)
        purchase_name = purchase.get('description', 'N/A')
        deduction = 100
        reason = "Receipt not provided - 100 point penalty."
        receipt_filename = "N/A"

        current_points = customer_record.get("points", 1000)
        customer_record["points"] = max(current_points - deduction, 0)
        justified_record = {
            "purchase": purchase,
            "deduction": deduction,
            "analysis_reason": reason, # Renamed from ai_reason
            "receipt_filename": receipt_filename,
            "justification": "N/A"
        }
        customer_record.setdefault("justified", []).append(justified_record)
        save_data(purchase_data)

        logging.info(f"Applied penalty for '{purchase_name}' ({customer}).")
        flash(f"Skipped '{purchase_name}'. 100 points deducted.", "warning")

    except Exception as e:
        logging.exception(f"Error in /penalize for {customer}: {e}")
        flash(f"An error occurred while applying the penalty: {e}", "error")

    return redirect(url_for('dashboard', view='pending'))


@app.route('/leaderboard', methods=['GET'])
def leaderboard():
    current_data = load_data() # Load fresh data for leaderboard
    if not isinstance(current_data, dict):
        flash("Leaderboard data is currently unavailable.", "error")
        return redirect(url_for('login'))

    leaderboard_list = [
        (user, info.get("points", 0))
        for user, info in current_data.items()
        if isinstance(info, dict) and user in config.ALLOWED_USERNAMES
    ]
    leaderboard_list.sort(key=lambda x: x[1], reverse=True)
    leaderboard_ranked = [(rank + 1, customer, points) for rank, (customer, points) in enumerate(leaderboard_list)]

    return render_template('leaderboard.html', leaderboard=leaderboard_ranked)


@app.route('/receipts/<path:filename>')
@login_required
def view_receipt(filename):
    customer = session['username']
    customer_prefix = customer.replace(' ', '_') + "_"

    # Basic security check based on filename prefix convention
    if not filename.startswith(customer_prefix):
         logging.warning(f"Access denied for {customer} to view receipt {filename}")
         flash("You do not have permission to view this receipt.", "error")
         return redirect(url_for('dashboard'))

    logging.info(f"Serving receipt {filename} for user {customer}")
    try:
        # Serve file from the UPLOAD_FOLDER defined in config and created in __init__
        return send_from_directory(
            current_app.config['UPLOAD_FOLDER'],
            filename,
            as_attachment=False
        )
    except FileNotFoundError:
        logging.error(f"Receipt file not found: {filename} (requested by {customer})")
        flash("Receipt file not found.", "error")
        return redirect(url_for('dashboard', view='history'))

# Static files route (for logo, CSS) is implicitly handled by Flask
# when static_folder is set correctly in app/__init__.py
# But if you need an explicit route (e.g., for files outside 'static'), keep it.
# The default setup should work for CSS and logo.webp in app/static/