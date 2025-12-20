"""
REST API: Students (Based on Flask + CSV File as storage)
"""

from flask import Flask, jsonify, request
import csv
import os

app = Flask(__name__)

# ====== Main settings ======
CSV_FILE = "students.csv"
ALLOWED_FIELDS = {"name", "surname", "age"}  # allowed for requests POST/PUT


# ====== Work with CSV: Reading ======
def read_students():
    students = []

    if not os.path.exists(CSV_FILE):
        return students

    with open(CSV_FILE, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            students.append({
                "id": int(row["id"]),
                "name": row["name"],
                "surname": row["surname"],
                "age": int(row["age"])
            })

    return students


# ====== Work with CSV: recording ======
def write_students(students):
    with open(CSV_FILE, "w", newline="", encoding="utf-8") as f:
        fieldnames = ["id", "name", "surname", "age"]
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for s in students:
            writer.writerow(s)


# ====== New ID ======
def generate_new_id(students):
    if not students:
        return 1
    return max(s["id"] for s in students) + 1


# ====== GET: Show all students ======
@app.route("/students", methods=["GET"])
def get_students():
    students = read_students()
    return jsonify(students), 200


# ====== GET: Show students by ID ======
@app.route("/students/<int:student_id>", methods=["GET"])
def get_student_by_id(student_id):
    students = read_students()

    for s in students:
        if s["id"] == student_id:
            return jsonify(s), 200

    return jsonify({"error": "Student not found"}), 404


# ====== GET: Show student by surname ======
@app.route("/students/search", methods=["GET"])
def get_students_by_surname():
    surname = request.args.get("surname")

    if not surname:
        return jsonify({"error": "Surname query parameter is required"}), 400

    students = read_students()
    result = [s for s in students if s["surname"] == surname]

    if not result:
        return jsonify({"error": "Student not found"}), 404

    return jsonify(result), 200


# ====== POST: Create new student ======
@app.route("/students", methods=["POST"])
def create_student():
    data = request.get_json()

    if not data:
        return jsonify({"error": "Request body is empty"}), 400

    if not set(data.keys()).issubset(ALLOWED_FIELDS):
        return jsonify({"error": "Invalid field in request body"}), 400

    if not ALLOWED_FIELDS.issubset(data.keys()):
        return jsonify({"error": "Missing required fields"}), 400

    students = read_students()
    new_id = generate_new_id(students)

    new_student = {
        "id": new_id,
        "name": data["name"],
        "surname": data["surname"],
        "age": int(data["age"])
    }

    students.append(new_student)
    write_students(students)

    return jsonify(new_student), 201


# ====== PUT: Recreating student by ID ======
@app.route("/students/<int:student_id>", methods=["PUT"])
def update_student(student_id):
    data = request.get_json()

    if not data:
        return jsonify({"error": "Request body is empty"}), 400

    # forbidden unknown fields
    if not set(data.keys()).issubset(ALLOWED_FIELDS):
        return jsonify({"error": "Invalid field in request body"}), 400

    # PUT Demand all 3 fields
    if not ALLOWED_FIELDS.issubset(data.keys()):
        return jsonify({"error": "Missing required fields"}), 400

    students = read_students()

    for s in students:
        if s["id"] == student_id:
            s["name"] = data["name"]
            s["surname"] = data["surname"]
            s["age"] = int(data["age"])

            write_students(students)
            return jsonify(s), 200

    return jsonify({"error": "Student not found"}), 404


# ====== PATCH: renew age by ID ======
@app.route("/students/<int:student_id>", methods=["PATCH"])
def update_student_age(student_id):
    data = request.get_json()

    if not data:
        return jsonify({"error": "Request body is empty"}), 400

    if set(data.keys()) != {"age"}:
        return jsonify({"error": "Only 'age' field can be updated"}), 400

    students = read_students()

    for s in students:
        if s["id"] == student_id:
            s["age"] = int(data["age"])
            write_students(students)
            return jsonify(s), 200

    return jsonify({"error": "Student not found"}), 404


# ====== DELETE: Delete student by ID ======
@app.route("/students/<int:student_id>", methods=["DELETE"])
def delete_student(student_id):
    students = read_students()

    for i, s in enumerate(students):
        if s["id"] == student_id:
            students.pop(i)
            write_students(students)
            return jsonify({"message": "Student deleted"}), 200

    return jsonify({"error": "Student not found"}), 404


# ====== Entry point ======
if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5001, debug=True)

