DROP TABLE IF EXISTS activity_logs;

CREATE TABLE activity_logs (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    action_type TEXT NOT NULL,
    resource TEXT NOT NULL,
    ts TIMESTAMP NOT NULL,
    metadata TEXT
);

CREATE INDEX idx_activity_user_ts
ON activity_logs (user_id, ts DESC);