/*
=========================================================
  Banking Data Warehouse – Analytical SQL Queries
  Author: Mehmet Baştürk
  Description:
    This script contains 20+ analytical SQL queries built
    on top of the following dimensional model:

      - fact_transaction
      - dim_customer
      - dim_branch
      - dim_card
      - dim_loan
      - dim_date

=========================================================
*/


---------------------------------------------------------
-- 1) Top Customers by Transaction Count and Amount
---------------------------------------------------------
SELECT dc.customer_id,
       dc.first_name,
       dc.last_name,
       COUNT(*) AS transaction_count,
       SUM(f.transaction_amount) AS total_amount
FROM fact_transaction f
JOIN dim_customer dc ON f.customer_sk = dc.customer_sk
GROUP BY 1,2,3
ORDER BY transaction_count DESC;


---------------------------------------------------------
-- 2) City-Level Transaction Summary
---------------------------------------------------------
SELECT db.city,
       COUNT(*) AS txn_count,
       SUM(f.transaction_amount) AS total_amount
FROM fact_transaction f
JOIN dim_branch db ON f.branch_sk = db.branch_sk
GROUP BY db.city
ORDER BY txn_count DESC;


---------------------------------------------------------
-- 3) Monthly Transaction Trend
---------------------------------------------------------
SELECT dd.year,
       dd.month,
       SUM(f.transaction_amount) AS total_amount
FROM fact_transaction f
JOIN dim_date dd ON f.transaction_date_sk = dd.date_sk
GROUP BY dd.year, dd.month
ORDER BY dd.year, dd.month;


---------------------------------------------------------
-- 4) Transaction Type Breakdown
---------------------------------------------------------
SELECT transaction_type,
       COUNT(*) AS txn_count,
       SUM(transaction_amount) AS total_amount
FROM fact_transaction
GROUP BY transaction_type
ORDER BY total_amount DESC;


---------------------------------------------------------
-- 5) Average Transaction Amount by Branch
---------------------------------------------------------
SELECT db.city,
       AVG(f.transaction_amount) AS avg_amount
FROM fact_transaction f
JOIN dim_branch db ON f.branch_sk = db.branch_sk
GROUP BY db.city
ORDER BY avg_amount DESC;


---------------------------------------------------------
-- 6) Highest Balance After Transaction
---------------------------------------------------------
SELECT *
FROM fact_transaction
ORDER BY balance_after_transaction DESC
LIMIT 20;


---------------------------------------------------------
-- 7) Card Type Spending Summary
---------------------------------------------------------
SELECT dcard.card_type,
       SUM(f.transaction_amount) AS total_spend
FROM fact_transaction f
JOIN dim_card dcard ON f.card_sk = dcard.card_sk
GROUP BY dcard.card_type
ORDER BY total_spend DESC;


---------------------------------------------------------
-- 8) Loan Type and Status Summary
---------------------------------------------------------
SELECT loan_type,
       loan_status,
       COUNT(*) AS loan_count,
       AVG(interest_rate) AS avg_interest
FROM dim_loan
GROUP BY loan_type, loan_status
ORDER BY loan_count DESC;


---------------------------------------------------------
-- 9) Annual Customer Spend
---------------------------------------------------------
SELECT dc.customer_id,
       dd.year,
       SUM(f.transaction_amount) AS annual_spend
FROM fact_transaction f
JOIN dim_customer dc ON f.customer_sk = dc.customer_sk
JOIN dim_date dd ON f.transaction_date_sk = dd.date_sk
GROUP BY 1,2
ORDER BY annual_spend DESC;


---------------------------------------------------------
-- 10) Max Transaction Per Customer
---------------------------------------------------------
SELECT dc.customer_id,
       MAX(f.transaction_amount) AS max_transaction
FROM fact_transaction f
JOIN dim_customer dc ON f.customer_sk = dc.customer_sk
GROUP BY 1
ORDER BY max_transaction DESC;


---------------------------------------------------------
-- 11) Anomaly (Fraud Risk) Report
---------------------------------------------------------
SELECT *
FROM fact_transaction
WHERE anomaly_flag = TRUE
ORDER BY transaction_amount DESC;


---------------------------------------------------------
-- 12) Day-of-Week Heatmap
---------------------------------------------------------
SELECT dd.day_of_week,
       COUNT(*) AS txn_count
FROM fact_transaction f
JOIN dim_date dd ON dd.date_sk = f.transaction_date_sk
GROUP BY dd.day_of_week
ORDER BY dd.day_of_week;


---------------------------------------------------------
-- 13) Highest Revenue Branch
---------------------------------------------------------
SELECT db.city,
       SUM(f.transaction_amount) AS revenue
FROM fact_transaction f
JOIN dim_branch db ON f.branch_sk = db.branch_sk
GROUP BY db.city
ORDER BY revenue DESC;


---------------------------------------------------------
-- 14) High-Risk Loans
---------------------------------------------------------
SELECT *
FROM dim_loan
WHERE interest_rate > 5
   OR loan_term > 48
ORDER BY interest_rate DESC;


---------------------------------------------------------
-- 15) Customers Near Credit Limit
---------------------------------------------------------
SELECT dcard.card_id,
       dcard.card_type,
       dcard.credit_limit,
       f.balance_after_transaction
FROM fact_transaction f
JOIN dim_card dcard ON f.card_sk = dcard.card_sk
WHERE f.balance_after_transaction >= dcard.credit_limit * 0.8
ORDER BY f.balance_after_transaction DESC;


---------------------------------------------------------
-- 16) Multi-Dimensional Analysis (Branch x Loan)
---------------------------------------------------------
SELECT db.city,
       dl.loan_type,
       COUNT(*) AS txn_count,
       SUM(f.transaction_amount) AS total_amount
FROM fact_transaction f
JOIN dim_branch db ON f.branch_sk = db.branch_sk
JOIN dim_loan dl ON f.loan_sk = dl.loan_sk
GROUP BY db.city, dl.loan_type
ORDER BY total_amount DESC;


---------------------------------------------------------
-- 17) Average Customer Age
---------------------------------------------------------
SELECT AVG(age) AS avg_age
FROM dim_customer;


---------------------------------------------------------
-- 18) First and Last Transaction Dates
---------------------------------------------------------
SELECT MIN(dd.full_date) AS first_transaction,
       MAX(dd.full_date) AS last_transaction
FROM fact_transaction f
JOIN dim_date dd ON f.transaction_date_sk = dd.date_sk;


---------------------------------------------------------
-- 19) Transaction Amount Percentile Summary
---------------------------------------------------------
SELECT 
    percentile_cont(0.5) WITHIN GROUP (ORDER BY transaction_amount) AS median_amount,
    percentile_cont(0.9) WITHIN GROUP (ORDER BY transaction_amount) AS p90,
    percentile_cont(0.99) WITHIN GROUP (ORDER BY transaction_amount) AS p99
FROM fact_transaction;


---------------------------------------------------------
-- 20) Customer 360 Profile Summary
---------------------------------------------------------
SELECT 
    dc.customer_id,
    dc.first_name || ' ' || dc.last_name AS full_name,
    dc.city,
    SUM(f.transaction_amount) AS total_spent,
    COUNT(f.*) AS total_transactions,
    MAX(f.transaction_amount) AS max_transaction,
    SUM(CASE WHEN anomaly_flag THEN 1 ELSE 0 END) AS anomaly_count
FROM fact_transaction f
JOIN dim_customer dc ON f.customer_sk = dc.customer_sk
GROUP BY 1,2,3
ORDER BY total_spent DESC;
