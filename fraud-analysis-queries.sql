--Goal is to load 100k rows of transactional data into snowflake from csv file.

CREATE DATABASE fraud_analysis; -- create a new DB called fraud_analysis
USE DATABASE fraud_analysis; -- telling snowflake we want to work inside this DB
CREATE SCHEMA transactions; -- create schema insdie DB called transactions
USE SCHEMA transactions; --tell snowflake to work inside the transactions schema

--creating table for data. VARCHAR = text , FLOAT= decimal , BOOLEAN = TRUE/FLASE
CREATE TABLE fraud_data (
    transaction_id VARCHAR,
    timestamp VARCHAR,
    sender_account VARCHAR,
    receiver_account VARCHAR,
    amount FLOAT,
    transaction_type VARCHAR,
    merchant_category VARCHAR,
    location VARCHAR,
    device_used VARCHAR,
    is_fraud BOOLEAN,
    fraud_type VARCHAR,
    time_since_last_transaction FLOAT,
    spending_deviation_score FLOAT, -- how transaction deviates from normal spending patterns.
    velocity_score FLOAT, --how fast transactions are happening on account. high score = unusualrapid activity
    geo_anomaly_score FLOAT, -- how unusual transaction location is for account
    payment_channel VARCHAR,
    ip_address VARCHAR,
    device_hash VARCHAR
);
--verify all 100,000 rows loaded correctly into table from CSV and understand range of risk scores in dataset
SELECT 
    COUNT(*),
    MIN(velocity_score) AS min_velocity, -- 1
    MAX(velocity_score) AS max_velocity, -- 20
    MIN(spending_deviation_score) AS min_spending_dev, -- -4.15
    MAX(spending_deviation_score) AS max_spending_dev, -- 4.19
    MIN(geo_anomaly_score) AS min_geo_anomaly, -- 0
    MAX(geo_anomaly_score) AS max_geo_anomaly -- 1
FROM fraud_data;


------------------------------------------------------------------------------------------------------
--QUERY 1 : Overall fraud summary. total transactions, total fraud cases, fraud rate %
SELECT 
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 'TRUE' THEN 1 ELSE 0 END) AS total_fraud,
    ROUND(SUM(CASE WHEN is_fraud = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 3) AS fraud_rate_pct,
    ROUND(SUM(amount), 2) AS total_transaction_value,
    ROUND(AVG(amount), 2) AS avg_transaction_amount
FROM fraud_data;

--QUERY 2: Fraud rate by transaction type
SELECT 
    transaction_type,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 'TRUE' THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(SUM(CASE WHEN is_fraud = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 3) AS fraud_rate_pct
FROM fraud_data
GROUP BY transaction_type
ORDER BY fraud_rate_pct DESC;

--QUERY 3: Fraud by Merchant Category
SELECT 
    merchant_category,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 'TRUE' THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(SUM(CASE WHEN is_fraud = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 3) AS fraud_rate_pct
FROM fraud_data
GROUP BY merchant_category
ORDER BY fraud_rate_pct DESC;

--QUERY 4: Fraud by payment channel
SELECT 
    payment_channel,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 'TRUE' THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(SUM(CASE WHEN is_fraud = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 3) AS fraud_rate_pct
FROM fraud_data
GROUP BY payment_channel
ORDER BY fraud_rate_pct DESC;

--QUERY 5: Fraud by Device Used
SELECT 
    device_used,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 'TRUE' THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(SUM(CASE WHEN is_fraud = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 3) AS fraud_rate_pct
FROM fraud_data
GROUP BY device_used
ORDER BY fraud_rate_pct DESC;

--QUERY 6: Top 10 locations by Fraud count
SELECT 
    location,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 'TRUE' THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(SUM(CASE WHEN is_fraud = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 3) AS fraud_rate_pct
FROM fraud_data
GROUP BY location
ORDER BY fraud_count DESC
LIMIT 10;

--QUERY 7: High risk transactions
    -- Flags transactions with high velocity, spending deviation or geo anomaly scores
    -- These are the transactions to investigate first
SELECT 
    transaction_id,
    sender_account,
    amount,
    transaction_type,
    location,
    device_used,
    velocity_score,
    spending_deviation_score,
    geo_anomaly_score,
    is_fraud
FROM fraud_data
WHERE velocity_score > 8
   OR spending_deviation_score > 2
   OR geo_anomaly_score > 0.8
ORDER BY velocity_score DESC
LIMIT 20;

-- Query 8: True high risk transactions
-- Flags transactions where multiple risk scores are elevated simultaneously
-- highest priority cases for fraud investigation
SELECT 
    transaction_id,
    sender_account,
    amount,
    transaction_type,
    location,
    device_used,
    velocity_score,
    spending_deviation_score,
    geo_anomaly_score,
    is_fraud
FROM fraud_data
WHERE velocity_score > 5
AND spending_deviation_score > 1
AND geo_anomaly_score > 0.5
ORDER BY velocity_score DESC
LIMIT 20;

--findings from Query 7 and 8 show FALSE fraud detection even though high velocty, geo-anomoly and spend dev. Investigate further


-- Query 9: What do actual fraud transactions look like?
-- Examining the risk score profile of confirmed fraud cases
SELECT 
    AVG(velocity_score) AS avg_velocity,
    AVG(spending_deviation_score) AS avg_spending_deviation,
    AVG(geo_anomaly_score) AS avg_geo_anomaly,
    AVG(amount) AS avg_fraud_amount,
    MIN(amount) AS min_fraud_amount,
    MAX(amount) AS max_fraud_amount
FROM fraud_data
WHERE is_fraud = 'TRUE';
