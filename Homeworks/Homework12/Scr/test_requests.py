import requests
import json
from datetime import datetime

BASE_URL = "http://127.0.0.1:5001"
RESULTS_FILE = "results.txt"


def log(text, f):
    print(text)
    f.write(text + "\n")


def make_request(method, url, f, body=None):
    log(f"{method} {url}", f)

    if body is not None:
        log("Request body:", f)
        log(json.dumps(body, ensure_ascii=False), f)

    response = requests.request(method, url, json=body)
    log(f"Status: {response.status_code}", f)

    try:
        log("Response:", f)
        log(json.dumps(response.json(), ensure_ascii=False), f)
        return response.json()
    except Exception:
        log("Response:", f)
        log(response.text, f)
        return None


def main():
    with open(RESULTS_FILE, "w", encoding="utf-8") as f:
        log(f"Test run: {datetime.now()}", f)

        # 1. GET all students
        make_request("GET", f"{BASE_URL}/students", f)

        # 2. POST three students
        s1 = make_request(
            "POST", f"{BASE_URL}/students", f,
            {"name": "Anna", "surname": "Ivanova", "age": 20}
        )
        s2 = make_request(
            "POST", f"{BASE_URL}/students", f,
            {"name": "Bohdan", "surname": "Petrenko", "age": 21}
        )
        s3 = make_request(
            "POST", f"{BASE_URL}/students", f,
            {"name": "Marta", "surname": "Koval", "age": 22}
        )

        id1 = s1.get("id")
        id2 = s2.get("id")
        id3 = s3.get("id")

        # 3. GET all students
        make_request("GET", f"{BASE_URL}/students", f)

        # 4. PATCH second student age
        make_request(
            "PATCH", f"{BASE_URL}/students/{id2}", f,
            {"age": 25}
        )

        # 5. GET second student
        make_request("GET", f"{BASE_URL}/students/{id2}", f)

        # 6. PUT third student
        make_request(
            "PUT", f"{BASE_URL}/students/{id3}", f,
            {"name": "Marta", "surname": "Kovalchuk", "age": 30}
        )

        # 7. GET third student
        make_request("GET", f"{BASE_URL}/students/{id3}", f)

        # 8. GET all students
        make_request("GET", f"{BASE_URL}/students", f)

        # 9. DELETE first student
        make_request("DELETE", f"{BASE_URL}/students/{id1}", f)

        # 10. GET all students
        make_request("GET", f"{BASE_URL}/students", f)

        log("DONE", f)


if __name__ == "__main__":
    main()

