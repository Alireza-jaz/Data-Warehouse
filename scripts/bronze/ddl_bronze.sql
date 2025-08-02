/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/
IF OBJECT_ID('raw_transaction','U') IS NOT NULL
    DROP TABLE bronze.raw_transaction
;GO

CREATE TABLE raw_transaction(
	customer_id        NVARCHAR(250),
	customer_name      NVARCHAR(150),
	gender             NVARCHAR(15),
	age                INT,
	State              NVARCHAR(50),
    City               NVARCHAR(50),
    Bank_Branch        NVARCHAR(100),
    Account_Type       NVARCHAR(50),
    Transaction_ID     NVARCHAR(50),
    Transaction_Date   NVARCHAR(50),
    Transaction_Time   Time,
    Transaction_Amount DECIMAL(18,2),
    Merchant_ID        NVARCHAR(50),
    Transaction_Type   NVARCHAR(50),
    Merchant_Category  NVARCHAR(100),
    Account_Balance    DECIMAL(18,2),
    Transaction_Device NVARCHAR(50),
    Transaction_Location NVARCHAR(255),
    Device_Type        NVARCHAR(50),
    Is_Fraud           NVARCHAR(20),
    Transaction_Currency NVARCHAR(10),
    Customer_Contact   NVARCHAR(100),
    Transaction_Description NVARCHAR(255),
    Customer_Email     NVARCHAR(255),
    ANON NVARCHAR(255)
);
GO



CREATE TABLE bronze.raw_transaction(
	customer_id        NVARCHAR(250),
	customer_name      NVARCHAR(150),
	gender             NVARCHAR(15),
	age                INT,
	State              NVARCHAR(50),
    City               NVARCHAR(50),
    Bank_Branch        NVARCHAR(100),
    Account_Type       NVARCHAR(50),
    Transaction_ID     NVARCHAR(50),
    Transaction_Date   NVARCHAR(50),
    Transaction_Time   Time,
    Transaction_Amount DECIMAL(18,2),
    Merchant_ID        NVARCHAR(50),
    Transaction_Type   NVARCHAR(50),
    Merchant_Category  NVARCHAR(100),
    Account_Balance    DECIMAL(18,2),
    Transaction_Device NVARCHAR(50),
    Transaction_Location NVARCHAR(255),
    Device_Type        NVARCHAR(50),
    Is_Fraud           INT,
    Transaction_Currency NVARCHAR(10),
    Customer_Contact   NVARCHAR(100),
    Transaction_Description NVARCHAR(255),
    Customer_Email     NVARCHAR(255),
);
GO
