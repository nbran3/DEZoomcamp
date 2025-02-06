Week 3 folder for Data Engineering Zoomcamp


SQL queries : 

Q1 : 

SELECT count(tpep_pickup_datetime)
FROM `table_name`

Q2 : 

SELECT distinct count(PULocationID) 
FROM `table_name`

SELECT distinct count(PULocationID) 
FROM `table_name_external`

Q3 : 

SELECT PULocationID,  
FROM `table_name`

SELECT PULocationID,  DOLocationID
FROM `table_name`

Q4 :

SELECT count(fare_amount) 
FROM `table_name` 
WHERE fare_amount = 0

Q5 : 

CREATE TABLE table_name_partition
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID
AS 
SELECT *
FROM `table_name`

Q6 :

SELECT distinct (VendorID) 
FROM `table_name`
WHERE tpep_dropoff_datetime >= '2024-03-01 00:00:00' AND tpep_dropoff_datetime < '2024-03-16 00:00:00'

SELECT distinct (VendorID) 
FROM `table_name_partition`
WHERE tpep_dropoff_datetime >= '2024-03-01 00:00:00' AND tpep_dropoff_datetime < '2024-03-16 00:00:00'
