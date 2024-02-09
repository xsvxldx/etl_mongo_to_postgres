
-- View to get ratio of the captured data in the last 24, 8 and 2 hours
CREATE OR REPLACE VIEW captured_data AS
WITH last_ingestion AS (
	SELECT MAX(timestamp) max_ts
	FROM metadata.etl_log
	WHERE "table" = 'metadatas'
),
last_records AS (
	SELECT station, timestamp_arduino
	FROM stations.metadatas
	WHERE is_valid = true
	AND timestamp_arduino > (SELECT max_ts::timestamp - interval '24 hour' FROM last_ingestion)
)
SELECT
	station,
	COUNT(*)::REAL captured_24h,
	SUM(CASE WHEN timestamp_arduino > (SELECT max_ts::timestamp - interval '8 hour' FROM last_ingestion) THEN 1 ELSE 0 END)::REAL captured_8h,
	SUM(CASE WHEN timestamp_arduino > (SELECT max_ts::timestamp - interval '2 hour' FROM last_ingestion) THEN 1 ELSE 0 END)::REAL captured_2h
FROM last_records
GROUP BY 1

