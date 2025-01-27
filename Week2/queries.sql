--- Question 3 

SELECT count(unique_row_id) 
FROM `zoomcamp.yellow_tripdata` 
WHERE EXTRACT (YEAR FROM tpep_pickup_datetime) = 2020 OR EXTRACT (YEAR FROM tpep_dropoff_datetime) = 2020

--- Question 4
SELECT count(unique_row_id) 
FROM `zoomcamp.green_tripdata` 
WHERE EXTRACT (YEAR FROM lpep_pickup_datetime) = 2020 OR EXTRACT (YEAR FROM lpep_dropoff_datetime) = 2020

--- Question 5
SELECT count(unique_row_id) 
FROM `zoomcamp.yellow_tripdata` 
WHERE filename = "yellow_tripdata_2021-03.csv"
