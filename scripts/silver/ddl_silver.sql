/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/


USE  bank_transaction
GO;

IF OBJECT_ID('silver.customer','U') IS NOT NULL
	DROP TABLE silver.customer

CREATE TABLE silver.customer(
		customer_id			 NVARCHAR(50) PRIMARY KEY
	   ,customer_name		 NVARCHAR(50)
	   ,gender				 NVARCHAR(10)
	   ,age					 INT
	   ,state				 NVARCHAR(50)
	   ,city				 NVARCHAR(50)
	   ,bank_branch			 NVARCHAR(50)
	   ,account_type		 NVARCHAR(50)
	   ,contact				 NVARCHAR(50)
	   ,email				 NVARCHAR(50)
)

IF OBJECT_ID('silver.device','U') IS NOT NULL
	DROP TABLE silver.device

CREATE TABLE silver.device(
		transaction_id		 NVARCHAR(50) PRIMARY KEY
	   ,transaction_device	 NVARCHAR(50)
	   ,transaction_type		 NVARCHAR(50)
	   ,device_type		     NVARCHAR(50)
)

IF OBJECT_ID('silver.merchant','U') IS NOT NULL
	DROP TABLE silver.merchant

CREATE TABLE silver.merchant (
    Merchant_ID        VARCHAR(50) PRIMARY KEY,
    Merchant_Category  VARCHAR(100),
    Transaction_Description VARCHAR(200)
);

IF OBJECT_ID('silver.detail_date','U') IS NOT NULL
	DROP TABLE silver.detail_date

CREATE TABLE silver.detail_date (
    transaction_id   NVARCHAR(50) PRIMARY KEY,
    date             DATE,
    Year             INT,
    Quarter          NVARCHAR(10),
    Month            NVARCHAR(10),
    transaction_time TIME,
	transaction_location NVARCHAR(100)
);

IF OBJECT_ID('silver.fact_transaction','U') IS NOT NULL
	DROP TABLE silver.fact_transaction

CREATE TABLE silver.fact_transaction (
    transaction_id     VARCHAR(50) PRIMARY KEY,
    customer_id        VARCHAR(50) ,
    merchant_id        VARCHAR(50) ,
    transaction_amount DECIMAL(18,2),
    account_balance    DECIMAL(18,2),
    Is_Fraud           BIT);
