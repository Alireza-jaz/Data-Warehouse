/*
===============================================================================
 Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.
===============================================================================
*/

BULK INSERT raw_transaction
FROM 'C:\Users\sajad\Desktop\Bank_Transaction_Fraud_Detection.csv'
WITH (FIRSTROW=2,FIELDTERMINATOR=',',TABLOCK)

INSERT INTO bronze.raw_transaction(
    customer_id        ,
    customer_name      ,
    gender             ,
    age                ,
    State              ,
    City               ,
    Bank_Branch        ,
    Account_Type       ,
    Transaction_ID     ,
    Transaction_Date   ,
    Transaction_Time   ,
    Transaction_Amount ,
    Merchant_ID        ,
    Transaction_Type   ,
    Merchant_Category  ,
    Account_Balance    ,
    Transaction_Device ,
    Transaction_Location,
    Device_Type        ,
    Is_Fraud           ,
    Transaction_Currency ,
    Customer_Contact   ,
    Transaction_Description,
    Customer_Email)
SELECT customer_id
      ,customer_name
      ,gender
      ,age
      ,State
      ,City
      ,Bank_Branch
      ,Account_Type
      ,Transaction_ID
      ,Transaction_Date
      ,Transaction_Time
      ,Transaction_Amount
      ,Merchant_ID
      ,Transaction_Type
      ,Merchant_Category
      ,Account_Balance
      ,Transaction_Device
      ,CONCAT([Transaction_Location],',',[Device_Type])
      ,Is_Fraud
      ,Transaction_Currency
      ,Customer_Contact
      ,Transaction_Description
      ,Customer_Email      
      ,[ANON]
FROM raw_transaction

UPDATE bronze.raw_transaction
SET Transaction_Date = DATEADD(DAY, 
           ABS(CHECKSUM(NEWID())) % DATEDIFF(DAY, '2023-01-01', '2025-12-31'), 
           '2023-01-01');
