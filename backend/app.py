from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
import bcrypt

app = Flask(__name__)
CORS(app)

client = MongoClient("mongodb://localhost:27017/")
db = client["college_app"]
users_collection = db["users"]

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get("username")
    password = data.get("password")
    role = data.get("role")

    if not all([username, password, role]):
        return jsonify({"success": False, "message": "Missing credentials"}), 400

    user = users_collection.find_one({
        "username": username,
        "role": role
    })

    if user:
        if bcrypt.checkpw(password.encode('utf-8'), user['password'].encode('utf-8')):
            return jsonify({"success": True, "message": "Login successful", "role": role})
        else:
            return jsonify({"success": False, "message": "Invalid credentials"}), 401
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


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
