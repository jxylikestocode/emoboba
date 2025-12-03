from flask import Flask, jsonify, render_template, request, session, redirect, url_for
from dotenv import load_dotenv
import os
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash

load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY', 'dev-fallback-key-change-in-production')

def get_db():
    return mysql.connector.connect(
        host=os.getenv('MYSQL_HOST'),
        user=os.getenv('MYSQL_USER'),
        password=os.getenv('MYSQL_PASSWORD'),
        database=os.getenv('MYSQL_DB')
    )

# ==================== PAGE ROUTES ====================

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/recommend")
def recommend():
    mood = request.args.get('mood', 'happy')
    return render_template("recommend.html", mood=mood)

@app.route("/dish/<int:id>")
def dish_detail(id):
    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute('''SELECT d.*, r.name as restaurant_name, m.name as mood_name
                      FROM `dishes` d
                      JOIN `restaurants` r ON d.restaurant_id = r.id
                      JOIN `moods` m ON d.mood_id = m.id
                      WHERE d.id = %s''', (id,))
    dish = cursor.fetchone()

    cursor.close()
    conn.close()

    is_favourite = False
    if "user_id" in session:
        conn = get_db()
        cursor = conn.cursor(dictionary=True)
        cursor.execute('''SELECT * FROM `favourites` WHERE user_id = %s AND dish_id = %s''',
                      (session["user_id"], id))
        is_favourite = cursor.fetchone() is not None
        cursor.close()
        conn.close()

    return render_template("dish.html", dish=dish, is_favourite=is_favourite)

@app.route("/restaurant/<int:id>")
def restaurant_detail(id):
    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute('''SELECT * FROM `restaurants` WHERE id = %s''', (id,))
    restaurant = cursor.fetchone()

    # Generate gallery image paths based on main image pattern
    gallery_images = []
    if restaurant and restaurant['image_url']:
        base_path = restaurant['image_url'].replace('_01.jpg', '')
        for i in range(1, 5):
            gallery_images.append(f"{base_path}_0{i}.jpg")

    cursor.execute('''SELECT tag FROM `restaurant_tags` WHERE restaurant_id = %s''', (id,))
    tags = cursor.fetchall()

    cursor.execute('''SELECT d.*, m.name as mood_name FROM `dishes` d
                      JOIN `moods` m ON d.mood_id = m.id
                      WHERE d.restaurant_id = %s''', (id,))
    dishes = cursor.fetchall()

    cursor.close()
    conn.close()

    is_favourite = False
    if "user_id" in session:
        conn = get_db()
        cursor = conn.cursor(dictionary=True)
        cursor.execute('''SELECT * FROM `favourites` WHERE user_id = %s AND restaurant_id = %s''',
                      (session["user_id"], id))
        is_favourite = cursor.fetchone() is not None
        cursor.close()
        conn.close()

    return render_template("restaurant.html", restaurant=restaurant, tags=tags, dishes=dishes, is_favourite=is_favourite, gallery_images=gallery_images)

@app.route("/favourites")
def favourites():
    if "user_id" not in session:
        return redirect(url_for('login'))

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute('''SELECT d.*, r.name as restaurant_name
                      FROM `favourites` f
                      JOIN `dishes` d ON f.dish_id = d.id
                      JOIN `restaurants` r ON d.restaurant_id = r.id
                      WHERE f.user_id = %s AND f.dish_id IS NOT NULL''', (session["user_id"],))
    favourite_dishes = cursor.fetchall()

    cursor.execute('''SELECT r.*
                      FROM `favourites` f
                      JOIN `restaurants` r ON f.restaurant_id = r.id
                      WHERE f.user_id = %s AND f.restaurant_id IS NOT NULL''', (session["user_id"],))
    favourite_restaurants = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("favourites.html", favourite_dishes=favourite_dishes, favourite_restaurants=favourite_restaurants)

@app.route("/login", methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        conn = get_db()
        cursor = conn.cursor(dictionary=True)
        cursor.execute('''SELECT * FROM `users` WHERE email = %s''', (email,))
        user = cursor.fetchone()
        cursor.close()
        conn.close()

        if user and check_password_hash(user['password'], password):
            session["user_id"] = user['id']
            session["username"] = user['username']
            return redirect(url_for('home'))
        else:
            return render_template("login.html", error="Invalid email or password")

    return render_template("login.html")

@app.route("/register", methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']

        hashed_password = generate_password_hash(password)

        conn = get_db()
        cursor = conn.cursor()

        try:
            sql = "INSERT INTO users (username, email, password) VALUES (%s, %s, %s)"
            values = (username, email, hashed_password)
            cursor.execute(sql, values)
            conn.commit()
            cursor.close()
            conn.close()
            return redirect(url_for('login'))
        except mysql.connector.IntegrityError:
            cursor.close()
            conn.close()
            return render_template("register.html", error="Username or email already exists")

    return render_template("register.html")

@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for('home'))

# ==================== API ROUTES ====================

@app.route("/api/dishes")
def api_dishes():
    mood = request.args.get('mood')

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    if mood:
        cursor.execute('''SELECT d.*, r.name as restaurant_name, m.name as mood_name
                          FROM `dishes` d
                          JOIN `restaurants` r ON d.restaurant_id = r.id
                          JOIN `moods` m ON d.mood_id = m.id
                          WHERE m.name = %s''', (mood,))
    else:
        cursor.execute('''SELECT d.*, r.name as restaurant_name, m.name as mood_name
                          FROM `dishes` d
                          JOIN `restaurants` r ON d.restaurant_id = r.id
                          JOIN `moods` m ON d.mood_id = m.id''')

    rows = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(rows)

@app.route("/api/dishes/<int:id>")
def api_dish(id):
    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute('''SELECT d.*, r.name as restaurant_name, m.name as mood_name
                      FROM `dishes` d
                      JOIN `restaurants` r ON d.restaurant_id = r.id
                      JOIN `moods` m ON d.mood_id = m.id
                      WHERE d.id = %s''', (id,))
    dish = cursor.fetchone()

    cursor.close()
    conn.close()

    return jsonify(dish)

@app.route("/api/restaurants/<int:id>")
def api_restaurant(id):
    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute('''SELECT * FROM `restaurants` WHERE id = %s''', (id,))
    restaurant = cursor.fetchone()

    cursor.execute('''SELECT tag FROM `restaurant_tags` WHERE restaurant_id = %s''', (id,))
    tags = cursor.fetchall()
    restaurant['tags'] = [t['tag'] for t in tags]

    cursor.close()
    conn.close()

    return jsonify(restaurant)

@app.route("/api/moods")
def api_moods():
    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute('''SELECT * FROM `moods`''')
    rows = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify(rows)

@app.route("/api/favourites", methods=['GET', 'POST'])
def api_favourites():
    if "user_id" not in session:
        return jsonify({"error": "Not logged in"}), 401

    if request.method == 'POST':
        data = request.get_json()
        dish_id = data.get('dish_id')
        restaurant_id = data.get('restaurant_id')

        conn = get_db()
        cursor = conn.cursor()

        sql = "INSERT INTO favourites (user_id, dish_id, restaurant_id) VALUES (%s, %s, %s)"
        values = (session["user_id"], dish_id, restaurant_id)
        cursor.execute(sql, values)
        conn.commit()

        cursor.close()
        conn.close()

        return jsonify({"status": "success", "id": cursor.lastrowid})

    # GET request
    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute('''SELECT * FROM `favourites` WHERE user_id = %s''', (session["user_id"],))
    rows = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify(rows)

@app.route("/api/favourites/<int:id>", methods=['DELETE'])
def api_delete_favourite(id):
    if "user_id" not in session:
        return jsonify({"error": "Not logged in"}), 401

    conn = get_db()
    cursor = conn.cursor()

    cursor.execute('''DELETE FROM `favourites` WHERE id = %s AND user_id = %s''', (id, session["user_id"]))
    conn.commit()

    cursor.close()
    conn.close()

    return jsonify({"status": "success"})

@app.route("/api/favourites/toggle", methods=['POST'])
def api_toggle_favourite():
    if "user_id" not in session:
        return jsonify({"error": "Login required"}), 401

    data = request.get_json()
    item_id = data.get('id')
    item_type = data.get('type')

    # Convert to dish_id or restaurant_id based on type
    dish_id = item_id if item_type == 'dish' else None
    restaurant_id = item_id if item_type == 'restaurant' else None

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    # Check if already favourited
    if dish_id:
        cursor.execute('''SELECT * FROM `favourites` WHERE user_id = %s AND dish_id = %s''',
                      (session["user_id"], dish_id))
    else:
        cursor.execute('''SELECT * FROM `favourites` WHERE user_id = %s AND restaurant_id = %s''',
                      (session["user_id"], restaurant_id))

    existing = cursor.fetchone()

    if existing:
        # Remove favourite
        cursor.execute('''DELETE FROM `favourites` WHERE id = %s''', (existing['id'],))
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"action": "removed"})
    else:
        # Add favourite
        cursor2 = conn.cursor()
        sql = "INSERT INTO favourites (user_id, dish_id, restaurant_id) VALUES (%s, %s, %s)"
        values = (session["user_id"], dish_id, restaurant_id)
        cursor2.execute(sql, values)
        conn.commit()
        cursor2.close()
        conn.close()
        return jsonify({"action": "added"})

if __name__ == '__main__':
    app.run(debug=True)
