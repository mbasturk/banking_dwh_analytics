--fact_transaction

CREATE TABLE fact_transaction (
    transaction_sk SERIAL PRIMARY KEY,
    transaction_id INTEGER,
    customer_sk INT REFERENCES dim_customer(customer_sk),
    account_sk INT REFERENCES dim_account(account_sk),
    branch_sk INT REFERENCES dim_branch(branch_sk),
    card_sk INT REFERENCES dim_card(card_sk),
    loan_sk INT REFERENCES dim_loan(loan_sk),
    transaction_date_sk INT REFERENCES dim_date(date_sk),
    transaction_type TEXT,
    transaction_amount NUMERIC,
    balance_after_transaction NUMERIC,
    anomaly_flag BOOLEAN
);
