from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
import bcrypt
from datetime import datetime
from pymongo import DESCENDING

app = Flask(__name__)
CORS(app)

client = MongoClient("mongodb://localhost:27017/")
db = client["college_app"]
users_collection = db["users"]
timetable_collection = db["timetable"]
notices_collection = db['notices']
assignments_collection = db['assignments']
events_collection = db['events']


@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get("username")
    password = data.get("password")

    if not all([username, password]):
        return jsonify({"success": False, "message": "Missing credentials"}), 400

    user = users_collection.find_one({
        "username": username
    })

    if user and bcrypt.checkpw(password.encode('utf-8'), user['password'].encode('utf-8')):
        return jsonify({
            "success": True,
            "message": "Login successful",
            "role": user["role"],     # Return role from database
            "name": user["username"]      # Optional: Send name for profile
        })
    else:
        return jsonify({"success": False, "message": "Invalid credentials"}), 401


@app.route('/add_faculty', methods=['POST'])
def add_faculty():
    data = request.json
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({'success': False, 'message': 'Missing data'}), 400

    if users_collection.find_one({"username": username, "role": "faculty"}):
        return jsonify({'success': False, 'message': 'Faculty already exists'}), 409

    hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

    users_collection.insert_one({
        "username": username,
        "password": hashed_password,
        "role": "faculty"
    })

    return jsonify({'success': True, 'message': f'Faculty {username} added'}), 201

@app.route('/remove_faculty', methods=['DELETE'])
def remove_faculty():
    data = request.get_json()
    username = data.get('username')

    if not username:
        return jsonify({'success': False, 'message': 'Username required'}), 400

    result = users_collection.delete_one({"username": username, "role": "faculty"})

    if result.deleted_count == 0:
        return jsonify({'success': False, 'message': 'Faculty not found'}), 404

    return jsonify({'success': True, 'message': f'Faculty {username} removed'}), 200


@app.route('/add_student', methods=['POST'])
def add_student():
    data = request.json
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({'success': False, 'message': 'Missing data'}), 400

    if users_collection.find_one({"username": username, "role": "student"}):
        return jsonify({'success': False, 'message': 'Student already exists'}), 409

    hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

    users_collection.insert_one({
        "username": username,
        "password": hashed_password,
        "role": "student"
    })

    return jsonify({'success': True, 'message': f'Student {username} added'}), 201

@app.route('/remove_student', methods=['DELETE'])
def remove_student():
    data = request.get_json()
    username = data.get('username')

    if not username:
        return jsonify({'success': False, 'message': 'Username required'}), 400

    result = users_collection.delete_one({"username": username, "role": "student"})

    if result.deleted_count == 0:
        return jsonify({'success': False, 'message': 'Student not found'}), 404

    return jsonify({'success': True, 'message': f'Student {username} removed'}), 200

@app.route('/get_students', methods=['GET'])
def get_students():
    students = users_collection.find({"role": "student"}, {"_id": 0, "username": 1})
    student_list = [student["username"] for student in students]
    return jsonify({'success': True, 'students': student_list}), 200

@app.route('/update_timetable', methods=['POST'])
def update_timetable():
    data = request.get_json()
    day = data.get("day")
    classes = data.get("classes")  # List of dicts: [{time, subject, room}, ...]

    if not day or not classes:
        return jsonify({"success": False, "message": "Missing timetable data"}), 400

    result = timetable_collection.update_one(
        {"day": day},
        {"$set": {"classes": classes}},
        upsert=True
    )

    return jsonify({"success": True, "message": f"Timetable for {day} updated"}), 200

@app.route('/get_timetable', methods=['GET'])
def get_timetable():
    timetable = list(timetable_collection.find({}, {"_id": 0}))
    return jsonify({"success": True, "timetable": timetable}), 200

@app.route('/post_notice', methods=['POST'])
def post_notice():
    data = request.json
    title = data.get('title', '').strip()
    content = data.get('content', '').strip()

    if not title or not content:
        return jsonify({'success': False, 'message': 'Missing title or content'}), 400

    notice = {
        'title': title,
        'content': content,
        'timestamp': datetime.utcnow()
    }

    notices_collection.insert_one(notice)
    return jsonify({'success': True, 'message': 'Notice posted successfully'}), 201

@app.route('/get_notices', methods=['GET'])
def get_notices():
    # Fetch and sort by newest first
    notices = list(
        notices_collection.find({}, {'_id': 0})
        .sort('timestamp', DESCENDING)
    )
    return jsonify({'success': True, 'notices': notices}), 200

@app.route('/assign_assignment', methods=['POST'])
def assign_assignment():
    data = request.json
    title = data.get('title')
    description = data.get('description')
    due_date = data.get('due_date')  # Optional

    if not title or not description:
        return jsonify({'success': False, 'message': 'Missing fields'}), 400

    assignments_collection.insert_one({
        'title': title,
        'description': description,
        'due_date': due_date
    })

    return jsonify({'success': True, 'message': 'Assignment posted'}), 201


@app.route('/get_assignments', methods=['GET'])
def get_assignments():
    assignments = list(assignments_collection.find({}, {'_id': 0}))
    return jsonify({'assignments': assignments}), 200

@app.route('/add_event', methods=['POST'])
def add_event():
    data = request.json
    title = data.get('title')
    date = data.get('date')  # Expecting ISO format (YYYY-MM-DD)
    description = data.get('description')

    if not title or not date:
        return jsonify({'success': False, 'message': 'Missing title or date'}), 400

    events_collection.insert_one({
        'title': title,
        'date': date,
        'description': description
    })
    return jsonify({'success': True, 'message': 'Event added'}), 201

@app.route('/get_events', methods=['GET'])
def get_events():
    events = list(events_collection.find({}, {'_id': 0}))
    return jsonify({'events': events}), 200

@app.route('/change_password', methods=['POST'])
def change_password():
    data = request.get_json()
    username = data.get('username')
    current_password = data.get('password')  # ← must be 'password'
    new_password = data.get('new_password')

    if not all([username, current_password, new_password]):
        return jsonify({"success": False, "message": "Missing fields"}), 400

    user = users_collection.find_one({"username": username})
    if not user:
        return jsonify({"success": False, "message": "User not found"}), 404

    if not bcrypt.checkpw(current_password.encode('utf-8'), user['password'].encode('utf-8')):
        return jsonify({"success": False, "message": "Current password incorrect"}), 401

    # Hash new password and update
    hashed = bcrypt.hashpw(new_password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
    users_collection.update_one({"username": username}, {"$set": {"password": hashed}})

    return jsonify({"success": True, "message": "Password updated successfully"})

@app.route('/get_user_info', methods=['POST'])
def get_user_info():
    data = request.get_json()
    username = data.get('username')

    if not username:
        return jsonify({"success": False, "message": "Username is required"}), 400

    user = users_collection.find_one({"username": username})
    if not user:
        return jsonify({"success": False, "message": "User not found"}), 404

    return jsonify({
        "success": True,
        "name": user.get("name", "N/A"),  # assuming 'name' field exists
        "role": user.get("role", "N/A")
    })


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
