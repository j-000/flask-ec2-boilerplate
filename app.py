from server import app
from flask import render_template
from development_settings import DEVELOPMENT


@app.route('/')
def home():
  return render_template('home.html')


if __name__ == "__main__":
  if DEVELOPMENT:
    app.run(debug=True)
  else:
    app.run()