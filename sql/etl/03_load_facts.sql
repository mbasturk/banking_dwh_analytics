-- load fact_transaction
INSERT INTO fact_transaction (
    transaction_id,
    customer_sk,
    account_sk,
    branch_sk,
    card_sk,
    loan_sk,
    transaction_date_sk,
    transaction_type,
    transaction_amount,
    balance_after_transaction,
    anomaly_flag
)
SELECT
    s.Transaction_ID,
    dc.customer_sk,
    da.account_sk,
    db.branch_sk,
    dcard.card_sk,
    dl.loan_sk,
    dd.date_sk,
    s.Transaction_Type,
    s.Transaction_Amount,
    s.Account_Balance_After_Transaction,
    (s.Anomaly = 1) AS anomaly_flag
FROM stg_bank_data s
LEFT JOIN dim_customer dc
    ON dc.customer_id = s.Customer_ID
   AND dc.is_current = TRUE
LEFT JOIN dim_account da
    ON da.customer_id = s.Customer_ID
   AND da.account_type = s.Account_Type
LEFT JOIN dim_branch db
    ON db.branch_id = s.Branch_ID
LEFT JOIN dim_card dcard
    ON dcard.card_id = s.Card_ID
LEFT JOIN dim_loan dl
    ON dl.loan_id = s.Loan_ID
LEFT JOIN dim_date dd
    ON dd.full_date = s.Transaction_Date;