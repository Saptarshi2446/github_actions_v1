from flask import Flask, render_template_string, request

app = Flask(__name__)

html = """
<!doctype html>
<html>
<head>
    <title>My Flask App</title>
</head>
<body>
    <h1>Select an Option</h1>
    <form method="POST">
        <select name="choice">
            <option value="Option A">Option A</option>
            <option value="Option B">Option B</option>
            <option value="Option C">Option C</option>
        </select>
        <button type="submit">Submit</button>
    </form>
    {% if choice %}
        <div style="background: lightgrey; padding: 10px; margin-top: 20px; color: black;">
            You selected: {{ choice }}
        </div>
    {% endif %}
</body>
</html>
"""

@app.route("/", methods=["GET", "POST"])
def index():
    choice = None
    if request.method == "POST":
        choice = request.form.get("choice")
    return render_template_string(html, choice=choice)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
