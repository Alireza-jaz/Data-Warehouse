/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.customers_transaction
-- =============================================================================
IF OBJECT_ID('gold.customers_transaction','V') IS NOT NULL
 DROP VIEW gold.customers_transaction
GO

 CREATE VIEW gold.customers_transaction AS
 SELECT
		ROW_NUMBER()OVER(ORDER BY c.customer_id) AS customer_key
	   ,c.Customer_name
	   ,c.gender
	   ,c.age
	   ,CASE WHEN c.age BETWEEN 18 AND 24 THEN 'UNDER 25'
		WHEN c.age BETWEEN 25 AND 34 THEN 'YOUNG ADULTS'
		WHEN c.age BETWEEN 35 AND 44 THEN 'ADULTS'
		WHEN c.age BETWEEN 45 AND 54 THEN 'MIDDLE AGE'
		WHEN c.age BETWEEN 55 AND 64 THEN 'Pre-Retirement'
		ELSE 'SENIOR' 
		END AS age_group
		,c.account_type
		,f.transaction_amount
		,ROW_NUMBER()OVER(ORDER BY f.transaction_amount DESC) AS spend_ranking
		,CASE WHEN f.transaction_amount >= (1.7*AVG(f.transaction_amount)OVER()) THEN 'High Spend'
		WHEN f.transaction_amount <1.7*AVG(f.transaction_amount)OVER() AND f.transaction_amount >=AVG(f.transaction_amount)OVER() THEN 'Medium Spend'
		ELSE 'Less Spend'
		END AS spend_category
		,f.account_balance
		,ROW_NUMBER()OVER(ORDER BY f.account_balance DESC) AS account_balance_ranking
		,CASE WHEN f.account_balance >= 50000 THEN 'Permium'
		WHEN f.account_balance BETWEEN 10000 AND 50000 THEN 'Regular'
		ELSE 'Basic'
		END AS balance_category
		,t.device_type
FROM silver.fact_transaction f
LEfT JOIN silver.customer c
ON c.customer_id=f.customer_id
LEFT JOIN silver.device t
ON f.transaction_id=t.transaction_id
GO


-- =============================================================================
-- Create Dimension: gold.transaction_details
-- =============================================================================
IF OBJECT_ID('gold.transaction_details','V') IS NOT NULL
 DROP VIEW gold.transaction_details
GO

 CREATE VIEW gold.transaction_details AS
 SELECT
		f.customer_id
	   ,m.merchant_id
	   ,f.transaction_amount
	   ,m.Merchant_Category
	   ,f.Is_Fraud
	   ,d.date
	   ,d.transaction_time
	   ,d.Year
	   ,d.Quarter
	   ,d.Month
FROM silver.fact_transaction f
LEFT JOIN silver.merchant m
ON m.Merchant_ID=f.merchant_id
LEFT JOIN silver.detail_date d
ON d.transaction_id=f.transaction_id
GO

-- =============================================================================
-- Create Dimension: gold.customers_view
-- =============================================================================
IF OBJECT_ID('gold.customers_view','V') IS NOT NULL
DROP VIEW gold.customers_view
GO

CREATE VIEW gold.customers_view AS
SELECT
	ROW_NUMBER()OVER(ORDER BY c.customer_id) AS customer_key
   ,c.customer_name
   ,c.gender
   ,c.age
   ,CASE WHEN c.age BETWEEN 18 AND 24 THEN 'UNDER 25'
		WHEN c.age BETWEEN 25 AND 34 THEN 'YOUNG ADULTS'
		WHEN c.age BETWEEN 35 AND 44 THEN 'ADULTS'
		WHEN c.age BETWEEN 45 AND 54 THEN 'MIDDLE AGE'
		WHEN c.age BETWEEN 55 AND 64 THEN 'Pre-Retirement'
		ELSE 'SENIOR' 
		END AS age_group
   ,c.account_type
   ,f.transaction_amount
   ,f.account_balance
   ,m.Merchant_Category  merchant_category
   ,m.Transaction_Description  transaction_description
   ,t.transaction_device
   ,t.transaction_type
   ,t.device_type
   ,d.transaction_location
   ,f.Is_Fraud
   ,c.bank_branch
   ,d.date
   ,d.Year
   ,d.Quarter
   ,d.Month
   ,d.transaction_time
FROM silver.fact_transaction f 
LEFT JOIN silver.customer c
ON f.customer_id=c.customer_id
LEFT JOIN silver.merchant m
ON m.Merchant_ID=f.merchant_id
LEFT JOIN silver.detail_date d
ON d.transaction_id=f.transaction_id
LEFT JOIN silver.device t
ON t.transaction_id=f.transaction_id
GO

-- ============================================
-- KPI
-- ============================================

-- =============================================================================
-- KPI : gold.fraud_summary
-- =============================================================================
IF OBJECT_ID ('gold.fraud_summary','V') IS NOT NULL
	DROP VIEW gold.fraud_summary
GO;

CREATE VIEW gold.fraud_summary AS
SELECT 
	d.Year year
   ,d.Quarter quarter
   ,SUM(f.transaction_amount) AS quarter_transaction
   ,SUM(CASE WHEN f.Is_Fraud=1 THEN 1 ELSE 0 END) AS total_fraud
   ,ROUND(
		100.0 * SUM(CASE WHEN f.Is_Fraud=1 THEN 1 ELSE 0 END)/Count(*),2) AS fraud_rate
   FROM silver.fact_transaction f
LEFT JOIN silver.detail_date d ON d.transaction_id=f.transaction_id
GROUP BY d.year,d.Quarter
GO

-- =============================================================================
-- KPI : gold.overtime_transaction
-- =============================================================================
IF OBJECT_ID ('gold.overtime_transaction','V') IS NOT NULL
	DROP VIEW gold.overtime_transaction
GO 

CREATE VIEW gold.overtime_transaction AS
SELECT
	 d.Year
	,d.Quarter
	,d.Month
	,COUNT(*) AS total_transactions
	,SUM(f.transaction_amount) AS monthly_transaction_amount
FROM silver.fact_transaction f 
LEFT JOIN silver.detail_date d
ON d.transaction_id=f.transaction_id
GROUP BY  d.Year,d.Quarter,d.Month
GO

-- =============================================================================
-- KPI : gold.customer_segmentation
-- =============================================================================
IF OBJECT_ID('gold.customer_segmentation','V') IS NOT NULL
	DROP VIEW gold.customer_segmentation

CREATE VIEW gold.customer_segmentation AS
SELECT 
	 ROW_NUMBER()OVER(ORDER BY c.customer_id) AS customer_key
	,c.customer_name
	,c.gender
	,c.age
	,f.transaction_amount
	,CASE 
        WHEN f.transaction_amount > 5000 THEN 'High Spender'
        WHEN f.transaction_amount BETWEEN 1000 AND 5000 THEN 'Medium Spender'
        ELSE 'Low Spender'
    END AS spending_segment   
    ,f.account_balance
FROM silver.fact_transaction f
LEFT JOIN silver.customer c ON c.customer_id=f.customer_id
GO
