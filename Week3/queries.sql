---Q1 : 
SELECT count(tpep_pickup_datetime) 
FROM table_name

---Q2 : 
SELECT distinct count(PULocationID) 
FROM table_name

SELECT distinct count(PULocationID) 
FROM table_name_external

--Q3 : 
SELECT PULocationID,
FROM table_name

SELECT PULocationID, DOLocationID 
FROM table_name

--- Q4 : 
SELECT count(fare_amount) 
FROM table_name 
WHERE fare_amount = 0
