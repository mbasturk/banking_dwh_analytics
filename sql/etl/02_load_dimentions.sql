-- load dim_branch
INSERT INTO dim_branch (branch_id, city)
SELECT DISTINCT Branch_ID, City
FROM stg_bank_data
WHERE Branch_ID IS NOT NULL;

-- load dim_customer
INSERT INTO dim_customer (
    customer_id, first_name, last_name, gender,
    city, address, email, contact_number,
    valid_from, valid_to, is_current
)
SELECT DISTINCT
    Customer_ID, First_Name, Last_Name, Gender,
    City, Address, Email, Contact_Number,
    CURRENT_DATE, TO_DATE('9999-12-31','YYYY-MM-DD') AS valid_to, TRUE
FROM stg_bank_data;

-- load dim_account
INSERT INTO dim_account (customer_id, account_type)
SELECT DISTINCT Customer_ID, Account_Type
FROM stg_bank_data;

-- load dim_loan
INSERT INTO dim_loan (
    loan_id, loan_type, interest_rate,
    loan_term, loan_status
)
SELECT DISTINCT
    Loan_ID, Loan_Type, Interest_Rate,
    Loan_Term, Loan_Status
FROM stg_bank_data
WHERE Loan_ID IS NOT NULL;

-- load dim_card
INSERT INTO dim_card (card_id, card_type, credit_limit)
SELECT DISTINCT
    Card_ID, Card_Type, Credit_Limit
FROM stg_bank_data
WHERE Card_ID IS NOT NULL;

-- load dim_date
INSERT INTO dim_date (full_date, year, month, day, month_name, day_of_week)
SELECT DISTINCT
    d::date AS full_date,
    EXTRACT(YEAR FROM d)::int,
    EXTRACT(MONTH FROM d)::int,
    EXTRACT(DAY FROM d)::int,
    TO_CHAR(d, 'Month'),
    EXTRACT(DOW FROM d)::int
FROM (
    SELECT Transaction_Date AS d FROM stg_bank_data
    UNION
    SELECT Date_Of_Account_Opening FROM stg_bank_data
) x
WHERE d IS NOT NULL
ON CONFLICT (full_date) DO NOTHING;

--load dim_customer_type2
INSERT INTO dim_customer_type2 (
    customer_id, first_name, last_name, gender,
    city, address, email, contact_number,
    valid_from, valid_to, is_current
)
SELECT DISTINCT
    Customer_ID, First_Name, Last_Name, Gender,
    City, Address, Email, Contact_Number,
    CURRENT_DATE,
    DATE '9999-12-31',
    TRUE
FROM stg_bank_data;