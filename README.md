Banking Data Warehouse & Analytics Project  
**PostgreSQL • Power BI • Dimensional Modeling (Kimball Method)**

This project is an end-to-end **analytics and data warehousing solution** built on top of a fictional banking dataset.  
It includes a PostgreSQL Data Warehouse, ETL processes, dimensional modeling, and two fully designed Power BI dashboards.

The project reflects the real workflow of a Data Engineer / BI Developer and serves as a strong portfolio example.

---

1. Architecture Overview

The solution consists of three main components:

1. **PostgreSQL Data Warehouse (DWH)**  
2. **ETL SQL scripts (data loading + SCD2 logic)**  
3. **Power BI Dashboards (Customer 360 & Transaction Analytics)**  

The data model follows the **Kimball Star Schema** approach optimized for analytical workloads.

---

2. Dimensional Model (Star Schema)

Fact Table  
fact_transaction 
- transaction_amount  
- transaction_type  
- foreign keys → customer, account, branch, loan, date, card  

Dimension Tables
- dim_customer_type2 (SCD Type 2 – Slowly Changing Dimension)  
- dim_customer 
- dim_account
- dim_branch  
- dim_card  
- dim_loan  
- dim_date  

---

3. ETL Processes & SQL Scripts

All ETL scripts are included under the `/sql` directory:

- 01_dim_customer.sql  
- 02_dim_account.sql  
- 03_dim_branch.sql  
- 04_dim_card.sql
- 05_dim_date.sql
- 06_dim_loan.sql
- 07_fact_transaction.sql  
- 08_relationships.sql  
- schema_dump.sql → *full PostgreSQL dump (schema + data)*  

Using the dump file, the entire DWH can be recreated with a single command.

---

4. PostgreSQL DWH Installation

Create and load the database:
createdb banking_dw
psql -U postgres -d banking_dw -f sql/banking_dw_schema.sql
All dimension and fact tables will be created automatically.

---

5. Power BI Dashboards
Power BI file: /powerbi/banking_dwh_analytics.pbix
Customer 360 Dashboard
Includes:

Total Customers

Active vs Inactive Customers

Gender Distribution

Customers by City

New Customers Over Time

Customer Details Table

Transaction Analytics Dashboard
Includes:

Total Transaction Amount

Total Transactions

Average Transaction Amount

Credit / Debit Ratio

Transaction Amount by Type

Transaction Trend Over Time

---

6. Technologies Used
Technology	Purpose
PostgreSQL	Data Warehouse storage
SQL	ETL, SCD Type 2 logic, transformations
Power BI	Data visualization & analytics
DAX	KPI & measure calculations
Kimball Star Schema	Dimensional modeling
pgAdmin 4	DB management

---

7. How to Run the Project
-Load the PostgreSQL database
psql -U postgres -d banking_dw -f sql/banking_dw_schema.sql
-Open the Power BI file
powerbi/Banking_DW_Dashboard.pbix
- Update the data source connection
Home → Transform Data → Data Source Settings

Update PostgreSQL connection (server: localhost, database: postgres)

Refresh all visuals

---

8. Screenshots (Recommended)
Add these under /screenshots:

Customers.jpg

Transactions.jpg

postgre.jpg

---

9. Purpose of the Project
This project demonstrates:

Data Warehouse design using Star Schema

ETL pipeline development

SQL proficiency

SCD2 implementation

DAX measure creation

Advanced Power BI reporting

Realistic banking analytics scenarios

It is ideal for Data Engineering / BI Developer portfolios.

---

10. Contact & Contributions
Feel free to open an issue for suggestions, improvements, or questions.
linkedin.com/in/mehmet-basturk/