from server import app, render_template


@app.route('/')
def home():
    return render_template('home.html')


if __name__ == "__main__":
    app.run()