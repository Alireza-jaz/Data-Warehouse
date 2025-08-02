# Bank Transaction Data Warehouse (SQL Project)

This project demonstrates the design and implementation of a SQL-based Data Warehouse for a simulated banking dataset.  
The solution follows a Bronze → Silver → Gold layered architecture to organize raw transactional data into structured, analysis-ready tables and views.


 #Project Structure

Bronze Layer : Raw transactional data loaded directly from flat files (CSV) without modifications.
Silver Layer : Cleaned and structured data, split into Fact and Dimension tables (Star Schema).
Gold Layer : Business-ready views with derived KPIs and customer profiling, prepared for visualization and reporting.

# Technologies Used

- Microsoft SQL Server  
- T-SQL (Views, Joins, Window Functions)  
- Star Schema Modeling  
- Git & GitHub (for versioning and portfolio)  
- Tableau (planned for visualization layer)  



#Data Model (Silver Layer)

The Silver Layer is designed in Star Schema format:

Fact Table
 silver.fact_transaction: Transactional records with amounts, balances, fraud flags, and references to dimensions.

Dimension Tables
  silver.customer
  silver.merchant
  silver.device
  silver.detail_date

# Analytical Views (Gold Layer)

| View Name | Description |

| gold.customers_transaction | Categorizes customers by age group, spending, and account balance tier. |
| gold.transaction_details | Combines transaction, merchant, and date data with fraud labels. |
| gold.customers_view | A comprehensive all-in-one view (customer + merchant + transaction + date). |
| gold.fraud_summary | Shows fraud counts and fraud rate per quarter. |
| gold.overtime_transaction | Transaction volumes and amounts grouped by month/quarter. |
| gold.customer_segmentation | Classifies customers into High, Medium, and Low spenders. |


#Example KPIs Built

- Customer Segmentation 
  - High, Medium, and Low spenders based on transaction amounts.  
- Account Balance Tiering
  - Premium, Regular, Basic categories by balance.  
- Fraud Rate Monitoring
  - Percentage of fraudulent transactions over total transactions (by quarter).  
- Transaction Trends 
  - Total and average transaction values per month/quarter.  

---

📌 How to Run the Project

1. Create a database: 'bank_transaction'
2.Create Schemas
3. Load raw CSV data into the Bronze Layer('bronze.raw_transaction') using BULK INSERT.
4. Transform data into the Silver Layer (fact , dimension tables).
5. Create Gold Layer Views using the provided SQL scripts.
6. Optionally connect Tableau or Power BI for visualization.


# Data-Warehouse
SQL Data Warehouse project for banking transactions using Bronze–Silver–Gold architecture. Includes data cleaning, schema design, and KPI analysis for fraud detection and customer segmentation
