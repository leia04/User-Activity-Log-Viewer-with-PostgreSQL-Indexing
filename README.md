# User Activity Log Viewer using PostgreSQL
A Flask-based user activity log viewer that demonstrates PostgreSQL B-tree indexing and query performance optimization.

## 1. Overview

This project is a Flask-based web application that allows users to retrieve and insert activity logs stored in a PostgreSQL database.

The primary goal of this project is to demonstrate how PostgreSQL query execution strategies, particularly B-tree indexing, directly impact application-level performance. The system compares index-based execution with sequential scans to highlight how proper index design significantly improves query efficiency.

---

## 2. Major Application Operations

The application supports the following operations:

1. **Retrieve recent activity logs for a user**
2. **Retrieve activity logs within a time range**
3. **Insert a new activity log**

Each operation is designed to demonstrate how PostgreSQL processes queries internally using B-tree indexes.

---

## 3. System Requirements

* Python 3.x
* PostgreSQL 17 (tested)
* pip (Python package manager)

---

## 4. Installation

### Install required Python packages

```bash
pip install -r requirements.txt
```

---

## 5. Database Setup

### Step 1: Start PostgreSQL

If PostgreSQL is not running:

```bash
pg_ctl -D /opt/homebrew/var/postgresql@17 start
```


### Step 2: Create database

```bash
createdb activity_app
```

### Step 3: Load schema

```bash
psql activity_app -f schema.sql
```

### Step 4: Load sample data

```bash
psql activity_app -f seed.sql
```

---

## 6. Environment Variables (Optional)

If your PostgreSQL username is different, set environment variables:

```bash
export DB_NAME=activity_app
export DB_USER=your_postgres_username
export DB_HOST=localhost
```

For example:

```bash
export DB_USER=leia
```

If not set, default values will be used.

---

## 7. Running the Application

Run the Flask application:

```bash
python app.py
```

Then open a browser and go to:

```
http://127.0.0.1:5000
```

---

## 8. How to Use the Application

Use the web interface to perform the following operations:

### Operation 1: Retrieve Recent Logs

* Enter a user ID (e.g., `400`)
* Click **Search Recent Logs**
* Displays the latest activity records sorted by timestamp


### Operation 2: Retrieve Logs Within Time Range

* Enter a user ID (e.g., `400`)
* Enter number of days (e.g., `90`)
* Click **Search Logs by Time Range**
* Displays logs within the specified time range


### Operation 3: Insert New Activity Log

* Enter:

  * User ID (e.g., `400`)
  * Action Type (e.g., `click`)
  * Resource (e.g., `/test`)
  * Metadata (optional)
* Click **Insert**
* New record will be added and visible in subsequent queries

---

## 9. Database Design

The database schema is defined in `schema.sql`, which creates the `activity_logs` table. The sample dataset is loaded through `seed.sql`.

### Table: activity_logs

| Column      | Type      | Description         |
| ----------- | --------- | ------------------- |
| id          | SERIAL    | Primary key         |
| user_id     | INT       | User identifier     |
| action_type | TEXT      | Type of action      |
| resource    | TEXT      | Resource path       |
| ts          | TIMESTAMP | Timestamp of action |
| metadata    | TEXT      | Additional info     |


### Index

A composite B-tree index is created:

```sql
CREATE INDEX idx_activity_user_ts
ON activity_logs (user_id, ts DESC);
```

This index optimizes queries that filter by `user_id` and sort by timestamp.

---

## 10. Demonstration Focus (Database Internals)

This project demonstrates the relationship between application behavior and database internals:

| Operation     | Database Behavior                                | Why It Matters                                      |
| ------------- | ------------------------------------------------ | --------------------------------------------------- |
| Retrieve logs | Index Scan using (user_id, ts DESC)              | Enables direct lookup and avoids unnecessary scanning and sorting |
| Range query   | Bitmap Index Scan + Bitmap Heap Scan             | Efficiently combines equality and range conditions  |
| Insert log    | Heap insert + index update                       | Maintains index consistency for efficient reads     |

---

## 11. Dataset & Analysis

This project includes a small synthetic dataset generated and loaded through `seed.sql`. Additional SQL queries used for execution plan analysis are included in `analysis.sql`.

---

## 12. Notes

* This project uses synthetic data for demonstration purposes.
* For best results, use `user_id = 400` during testing.
* Execution times may vary slightly depending on caching and system state.
* The application is designed for educational purposes and not for production use.

---

## 13. Author

Leia Kim  
USC Applied Data Science
