from server import app
from flask import render_template, flash, redirect, url_for
from development_settings import DEVELOPMENT
from flask_login import login_required, current_user, LoginManager, login_user, logout_user
from datamodels.Users import User

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

# User Loader
@login_manager.user_loader
def load_user(user_id):
  return User.query.get(int(user_id))

# Unauthorised Handler
@login_manager.unauthorized_handler
def unauthorized():
  flash('Please login to access your account.', 'info')
  return redirect(url_for('login'))

# Public Routes
@app.route('/')
def home():
  return render_template('home.html')

@app.route('/login')
def login():
  return render_template('login.html')

# Protected Routes
@app.route('/admin')
@login_required
def admin():
  return render_template('admin.html')

@app.route('/logout')
def logout():
  logout_user()
  flash('You have been logged out.', 'info')
  return redirect(url_for('home'))

if __name__ == "__main__":
  if DEVELOPMENT:
    app.run(debug=True)
  else:
    app.run()