from flask import Flask, render_template, request
import psycopg2
import os

app = Flask(__name__)

def get_connection():
    db_name = os.getenv("DB_NAME", "activity_app")
    db_user = os.getenv("DB_USER")
    db_host = os.getenv("DB_HOST", "localhost")
    db_port = os.getenv("DB_PORT", "5432")

    if not db_user:
        raise RuntimeError("DB_USER environment variable is not set.")

    return psycopg2.connect(
        dbname=db_name,
        user=db_user,
        host=db_host,
        port=db_port
    )


@app.route("/", methods=["GET", "POST"])
def index():
    logs = []
    filtered_logs = []
    inserted_message = None

    user_id = ""
    days = "90"

    if request.method == "POST":
        action = request.form.get("action")

        if action == "search_recent":
            user_id = request.form.get("user_id", "").strip()

            if user_id:
                conn = get_connection()
                cur = conn.cursor()
                cur.execute("""
                    SELECT id, user_id, action_type, resource, ts, metadata
                    FROM activity_logs
                    WHERE user_id = %s
                    ORDER BY ts DESC
                    LIMIT 50;
                """, (user_id,))
                logs = cur.fetchall()
                cur.close()
                conn.close()

        elif action == "search_range":
            user_id = request.form.get("user_id", "").strip()
            days = request.form.get("days", "90").strip()

            if user_id and days:
                conn = get_connection()
                cur = conn.cursor()
                cur.execute("""
                    SELECT id, user_id, action_type, resource, ts, metadata
                    FROM activity_logs
                    WHERE user_id = %s
                      AND ts >= NOW() - (%s || ' days')::interval
                    ORDER BY ts DESC
                    LIMIT 50;
                """, (user_id, days))
                filtered_logs = cur.fetchall()
                cur.close()
                conn.close()

        elif action == "insert_log":
            insert_user_id = request.form.get("insert_user_id", "").strip()
            action_type = request.form.get("action_type", "").strip()
            resource = request.form.get("resource", "").strip()
            metadata = request.form.get("metadata", "").strip()

            if insert_user_id and action_type and resource:
                conn = get_connection()
                cur = conn.cursor()
                cur.execute("""
                    INSERT INTO activity_logs (user_id, action_type, resource, ts, metadata)
                    VALUES (%s, %s, %s, NOW(), %s);
                """, (insert_user_id, action_type, resource, metadata))
                conn.commit()
                cur.close()
                conn.close()

                inserted_message = "Inserted successfully!"

    return render_template(
        "index.html",
        logs=logs,
        filtered_logs=filtered_logs,
        inserted_message=inserted_message,
        user_id=user_id,
        days=days
    )

if __name__ == "__main__":
    app.run(debug=True)
