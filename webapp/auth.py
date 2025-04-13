from functools import wraps
from flask import session, flash, redirect, url_for, request
from . import config # Import config from the app package

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'username' not in session:
            flash("Please log in to access this page.", "warning")
            return redirect(url_for('login.html', next=request.url))
        # Use config directly for ALLOWED_USERNAMES
        if session['username'] not in config.ALLOWED_USERNAMES:
             flash("Your user account is no longer valid. Please log in again.", "error")
             session.pop('username', None)
             return redirect(url_for('login.html'))
        return f(*args, **kwargs)
    return decorated_function