from flask import Flask, render_template, request, redirect, url_for 
from werkzeug.utils import secure_filename 
import psycopg2 
import os 

# 1) Create Flask app FIRST 
app = Flask(__name__) 
app.config['UPLOAD_FOLDER'] = 'static/uploads' 

# 2) Admin password (lab-level) 
ADMIN_PASSWORD = "Bluesky246" 

# 3) DB connection 
def get_db_connection(): 
    return psycopg2.connect( 
        host="localhost", 
        database="allu", 
        user="postgres", 
        password="Bluesky246"       
)

# ---------------- ROUTES ----------------

# Home (landing page)
@app.route('/')
def index():
    return render_template('index.html')

# About page
@app.route('/about')
def about():
    return render_template('about.html')

# Add student
@app.route('/add', methods=['GET', 'POST'])
def add():
    if request.method == 'POST':
        name = request.form['name']
        major = request.form['major']
        age = request.form['age']
        file = request.files['profile_image']

        if file and file.filename != '':
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

            conn = get_db_connection()
            cur = conn.cursor()
            cur.execute(
                "INSERT INTO profiles (name, major, age, image_filename) VALUES (%s, %s, %s, %s)",
                (name, major, age, filename)
            )
            conn.commit()
            cur.close()
            conn.close()

            return redirect(url_for('students'))

    return render_template('add_profile.html')

# View students (NO age)
@app.route('/students')
def students():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT id, name, major, image_filename FROM profiles")
    data = cur.fetchall()
    cur.close()
    conn.close()

    return render_template('students.html', students=data)

# Admin login
@app.route('/admin', methods=['GET', 'POST'])
def admin():
    if request.method == 'POST':
        password = request.form['password']
        if password == ADMIN_PASSWORD:
            conn = get_db_connection()
            cur = conn.cursor()
            cur.execute("SELECT * FROM profiles")
            data = cur.fetchall()
            cur.close()
            conn.close()
            return render_template('admin.html', students=data)
        else:
            return "Wrong Password ❌"

    return render_template('admin_login.html')

# Run
if __name__ == "__main__":
    os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
    app.run(debug=True)
