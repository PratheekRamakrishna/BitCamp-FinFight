import os
import logging
from flask import Flask, session # Added session import here as well
from . import config # Use relative import for config within the package

# Configure basic logging
logging.basicConfig(level=logging.INFO)

# Create Flask app instance
# Adjusted static/template folder paths relative to this file's location
app = Flask(__name__,
            static_folder='static',
            template_folder='templates')

# Load configuration from config.py
app.config.from_object(config)

# Set secret key from config
app.secret_key = app.config['SECRET_KEY']

# Ensure upload folder exists
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

# Register custom Jinja filter
@app.template_filter('enumerate')
def jinja_enumerate(iterable):
    return enumerate(iterable)

# Import routes after app is created to avoid circular imports
from . import routes