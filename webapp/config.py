import os

# Flask App Setup
# IMPORTANT: Change this to a strong, random secret key in a real application!
# Generate using: python -c 'import os; print(os.urandom(24))'
SECRET_KEY = 'your_secret_key_here_needs_to_be_strong_and_random'

# File/Folder Configuration
UPLOAD_FOLDER = 'receipts' # Relative to run.py location
DATA_FILE = 'purchase_data_v10.json' # Relative to run.py location

# External API Configuration
NESSIE_API_KEY = 'e9cc6b5785c915ecbd63f085317e2e91' # Replace if needed
BASE_URL = 'http://api.nessieisreal.com'

# Content Analysis Service Configuration
ANALYSIS_API_KEY_FALLBACK = "AIzaSyArpqryNlGbOB0uxYWi3yvfd2caUKwh1iA" # WARNING: Insecure
ANALYSIS_API_KEY = os.environ.get("ANALYSIS_API_KEY", ANALYSIS_API_KEY_FALLBACK)

# User Authentication Configuration
characters = [
    {'first_name': 'Dwarakesh', 'last_name': 'Arora'},
    {'first_name': 'Sanil', 'last_name': 'Baraneetharan'},
    {'first_name': 'Pratheek', 'last_name': 'Vignesh'},
    {'first_name': 'Narein', 'last_name': 'Ramakrishnan'},
    {'first_name': 'Rishab', 'last_name': 'Funkhouser'}
]
ALLOWED_USERNAMES = {f"{c['first_name']} {c['last_name']}" for c in characters}
# Hardcoded password for demonstration purposes ONLY.
CONCEPT_PASSWORD = "password"