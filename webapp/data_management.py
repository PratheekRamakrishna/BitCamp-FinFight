import os
import json
import requests
import logging
from . import config # Import config from the app package

def get_customers_from_api():
    url = f"{config.BASE_URL}/customers?key={config.NESSIE_API_KEY}"
    try:
        response = requests.get(url, timeout=15)
        response.raise_for_status()
        api_customers = response.json()
        customer_id_map = {}
        for cust in api_customers:
             fname = cust.get('first_name', '').strip()
             lname = cust.get('last_name', '').strip()
             name = f"{fname} {lname}"
             if name in config.ALLOWED_USERNAMES:
                 customer_id_map[name] = cust.get('_id')
        return customer_id_map
    except requests.exceptions.RequestException as e:
        logging.error(f"Customer API Error: {e}")
        return {}

def get_accounts_for_customer(customer_id):
    url = f"{config.BASE_URL}/customers/{customer_id}/accounts?key={config.NESSIE_API_KEY}"
    try:
        response = requests.get(url, timeout=15)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        logging.error(f"Account API Error {customer_id}: {e}")
        return []

def get_purchases_for_account(account_id):
    url = f"{config.BASE_URL}/accounts/{account_id}/purchases?key={config.NESSIE_API_KEY}"
    try:
        response = requests.get(url, timeout=15)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        logging.error(f"Purchase API Error {account_id}: {e}")
        return []

def build_customer_purchases_dict():
    customer_id_map = get_customers_from_api()
    customer_purchases = {}
    for name, cid in customer_id_map.items():
        if not cid:
            logging.warning(f"Skip User (no ID): {name}")
            continue
        customer_purchases[name] = []
        for acct in get_accounts_for_customer(cid):
            aid = acct.get('_id')
            if aid:
                customer_purchases[name].extend(get_purchases_for_account(aid))
            else:
                logging.warning(f"Skip Account for {name}: {acct}")
    logging.info(f"Built purchases for {len(customer_purchases)} allowed customers.")
    return customer_purchases

def initialize_data_file():
    data = {}
    cust_purch_dict = build_customer_purchases_dict()
    for username in config.ALLOWED_USERNAMES:
        purchases = cust_purch_dict.get(username, [])
        data[username] = {
            "pending": [p for p in purchases if p and p.get('_id')],
            "justified": [],
            "points": 1000
        }
    logging.info(f"Initializing data file for {len(data)} allowed customers.")
    save_data(data)
    return data

def load_data():
    data_file_path = config.DATA_FILE
    if os.path.exists(data_file_path):
        try:
            with open(data_file_path, 'r') as f:
                data = json.load(f)
            logging.info(f"Loaded {data_file_path}")
            if not isinstance(data, dict):
                raise ValueError("Invalid data format")

            needs_save = False
            for username in config.ALLOWED_USERNAMES:
                if username not in data:
                    logging.warning(f"User '{username}' not found in data file. Adding.")
                    data[username] = {"pending": [], "justified": [], "points": 1000}
                    needs_save = True
                else:
                    data[username].setdefault("pending", [])
                    data[username].setdefault("justified", [])
                    data[username].setdefault("points", 1000)
                    for item in data[username].get("justified", []):
                        item.setdefault("justification", "N/A")
                        item.setdefault("analysis_reason", item.pop("ai_reason", "N/A")) # Rename key

            keys_to_remove = [k for k in data if k not in config.ALLOWED_USERNAMES]
            if keys_to_remove:
                logging.warning(f"Removing users no longer allowed: {keys_to_remove}")
                for k in keys_to_remove:
                    del data[k]
                needs_save = True

            if needs_save:
                save_data(data)

            return data
        except (json.JSONDecodeError, ValueError, Exception) as e:
            logging.error(f"Error loading/validating {data_file_path}: {e}. Reinitializing.")
            return initialize_data_file()
    else:
        logging.info(f"{data_file_path} not found. Initializing.")
        return initialize_data_file()

def save_data(data):
    data_file_path = config.DATA_FILE
    try:
        data_to_save = {user: info for user, info in data.items() if user in config.ALLOWED_USERNAMES}
        with open(data_file_path, 'w') as f:
            json.dump(data_to_save, f, indent=4)
        logging.info(f"Saved {data_file_path} (filtered for allowed users)")
    except Exception as e:
        logging.error(f"Save failed {data_file_path}: {e}")

# Load data once when the module is imported
purchase_data = load_data()