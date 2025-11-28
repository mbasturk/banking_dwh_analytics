-- dim_customer

CREATE TABLE dim_customer (
    customer_sk SERIAL PRIMARY KEY,
    customer_id INTEGER,         -- business key
    first_name TEXT,
    last_name TEXT,
    gender TEXT,
    city TEXT,
    address TEXT,
    email TEXT,
    contact_number TEXT,
    valid_from DATE,
    valid_to DATE,
    is_current BOOLEAN
);


-- dim_branch

CREATE TABLE dim_branch (
    branch_sk SERIAL PRIMARY KEY,
    branch_id INTEGER,           -- business key
    city TEXT
);

-- dim_account

CREATE TABLE dim_account (
    account_sk SERIAL PRIMARY KEY,
    customer_id INTEGER,
    account_type TEXT
);


--dim_loan

CREATE TABLE dim_loan (
    loan_sk SERIAL PRIMARY KEY,
    loan_id INTEGER,
    loan_type TEXT,
    interest_rate NUMERIC,
    loan_term INTEGER,
    loan_status TEXT
);

--dim_card
CREATE TABLE dim_card (
    card_sk SERIAL PRIMARY KEY,
    card_id INTEGER,
    card_type TEXT,
    credit_limit NUMERIC
);


--dim_date
CREATE TABLE dim_date (
    date_sk SERIAL PRIMARY KEY,
    full_date DATE UNIQUE,
    year INT,
    month INT,
    day INT,
    month_name TEXT,
    day_of_week INT
);

--dim_customer_type2
CREATE TABLE dim_customer_type2 (
    customer_sk SERIAL PRIMARY KEY,
    customer_id INT,
    first_name TEXT,
    last_name TEXT,
    gender TEXT,
    city TEXT,
    address TEXT,
    email TEXT,
    contact_number TEXT,
    valid_from DATE,
    valid_to DATE,
    is_current BOOLEAN,
    UNIQUE (customer_id, valid_to)
);

--dim_customer_type2 change detection
WITH changes AS (
    SELECT s.*
    FROM stg_bank_data s
    JOIN dim_customer d
      ON d.customer_id = s.Customer_ID
     AND d.is_current = TRUE
    WHERE
       (d.first_name       <> s.First_Name OR d.first_name IS DISTINCT FROM s.First_Name)
    OR (d.last_name        <> s.Last_Name  OR d.last_name IS DISTINCT FROM s.Last_Name)
    OR (d.gender           <> s.Gender     OR d.gender IS DISTINCT FROM s.Gender)
    OR (d.city             <> s.City       OR d.city IS DISTINCT FROM s.City)
    OR (d.address          <> s.Address    OR d.address IS DISTINCT FROM s.Address)
    OR (d.email            <> s.Email      OR d.email IS DISTINCT FROM s.Email)
    OR (d.contact_number   <> s.Contact_Number OR d.contact_number IS DISTINCT FROM s.Contact_Number)
),

closed AS (
    UPDATE dim_customer d
       SET valid_to = CURRENT_DATE - 1,
           is_current = FALSE
      FROM changes c
     WHERE d.customer_id = c.Customer_ID
       AND d.is_current = TRUE
     RETURNING d.*
)

INSERT INTO dim_customer_type2 (
    customer_id, first_name, last_name, gender,
    city, address, email, contact_number,
    valid_from, valid_to, is_current
)
SELECT
    c.Customer_ID, c.First_Name, c.Last_Name, c.Gender,
    c.City, c.Address, c.Email, c.Contact_Number,
    CURRENT_DATE,
    DATE '9999-12-31',
    TRUE
FROM changes c;

