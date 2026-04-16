-- Operation 1: Without index
DROP INDEX IF EXISTS idx_activity_user_ts;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM activity_logs
WHERE user_id = 400
ORDER BY ts DESC
LIMIT 50;

-- Operation 1: With index
CREATE INDEX idx_activity_user_ts
ON activity_logs (user_id, ts DESC);

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM activity_logs
WHERE user_id = 400
ORDER BY ts DESC
LIMIT 50;

-- Operation 2: Time range query
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM activity_logs
WHERE user_id = 400
  AND ts >= NOW() - INTERVAL '90 days'
ORDER BY ts DESC;

-- Operation 3: Insert test
INSERT INTO activity_logs (user_id, action_type, resource, ts, metadata)
VALUES (400, 'click', '/test', NOW(), 'Chrome');

SELECT *
FROM activity_logs
WHERE user_id = 400
ORDER BY ts DESC
LIMIT 5;