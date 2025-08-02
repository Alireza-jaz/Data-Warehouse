/*
===============================================================================
Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    The ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
===============================================================================
*/

INSERT INTO silver.detail_date(transaction_id,date,Year,Quarter,Month,transaction_time,transaction_location)
SELECT 
	transaction_id,
	CONVERT(DATE,REPLACE(transaction_date,'/','-'),105),
	DATEPART(YEAR,(CONVERT(DATE,REPLACE(transaction_date,'/','-'),105))),
	'Q'+CAST(DATEPART(QUARTER,(CONVERT(DATE,REPLACE(transaction_date,'/','-'),105)))AS varchar),
	'M'+CAST(DATEPART(MONTH,(CONVERT(DATE,REPLACE(transaction_date,'/','-'),105)))AS varchar),
	FORMAT(CAST(transaction_time AS datetime2), 'HH:mm:ss'),
	REPLACE(REPLACE(Transaction_Location,'"',''),',',' ')
FROM bronze.raw_transaction



---
INSERT INTO silver.merchant(Merchant_ID,Merchant_Category,Transaction_Description)
SELECT
	Merchant_ID,
    CONCAT(SUBSTRING(UPPER(TRIM(Merchant_Category)),1,1),SUBSTRING(TRIM(Merchant_Category),2,LEN(TRIM(Merchant_Category)))),
	Transaction_Description
FROM bronze.raw_transaction



---
INSERT INTO silver.customer(customer_id,customer_name,gender,age,state,city,bank_branch,account_type,contact,email)
SELECT 
	customer_id,
	customer_name,
	gender,
	age,
	state,
	city,
	bank_branch,
	Account_Type,
	customer_contact,
	customer_email
FROM bronze.raw_transaction




---
INSERT INTO silver.device(transaction_id,transaction_device,transaction_type,device_type)
SELECT
	transaction_id,
	CONCAT(SUBSTRING(UPPER(TRIM(transaction_device)),1,1),SUBSTRING(TRIM(transaction_device),2,LEN(TRIM(transaction_device)))),
	transaction_type,
	CONCAT(SUBSTRING(UPPER(TRIM(device_type)),1,1),SUBSTRING(TRIM(device_type),2,LEN(TRIM(device_type))))
FROM bronze.raw_transaction




---
INSERT INTO silver.fact_transaction (transaction_id,customer_id,merchant_id,transaction_amount,account_balance,Is_Fraud)
SELECT 
	transaction_id
	,customer_id
	,merchant_id
	,transaction_amount
	,Account_Balance,
	Is_Fraud
FROM bronze.raw_transaction
