--- Question 3
SELECT count(index)
FROM public.green_taxi_data
WHERE trip_distance >= 1
    AND trip_distance < 3
    AND lpep_pickup_datetime >= '2019-10-01 00:00:00'
    AND lpep_pickup_datetime < '2019-11-01 00:00:00';



--- Question 4

SELECT count(index)
FROM public.green_taxi_data
WHERE trip_distance > 1
AND trip_distance <= 3
AND lpep_pickup_datetime >= '2019-10-01 00:00:00'
AND lpep_pickup_datetime < '2019-11-01 00:00:00';



--- Question 5
SELECT public.zone."Zone",  SUM(public.green_taxi_data.total_amount) AS total_amount_sum 
FROM public.green_taxi_data 
JOIN public.zone 
ON public.green_taxi_data."PULocationID" = public.zone."LocationID" 
WHERE public.green_taxi_data.lpep_pickup_datetime >= '2019-10-18 00:00:00'
    AND public.green_taxi_data.lpep_pickup_datetime < '2019-10-19 00:00:00'  
GROUP BY public.zone."Zone" 
HAVING SUM(public.green_taxi_data.total_amount) > 13000  
ORDER BY total_amount_sum DESC;  


--- Question 6 --- I did three queries for this, but you could have done it with only two with a double join
SELECT public.green_taxi_data."PULocationID"
FROM public.green_taxi_data
JOIN public.zone
ON public.green_taxi_data."PULocationID" = public.zone."LocationID"
WHERE public.zone."Zone" = 'East Harlem North';

SELECT public.green_taxi_data."DOLocationID", tip_amount 
FROM public.green_taxi_data
JOIN public.zone
ON public.green_taxi_data."PULocationID" = public.zone."LocationID"
WHERE public.green_taxi_data."PULocationID" = 74
ORDER by tip_amount DESC
LIMIT 1

SELECT public.green_taxi_data."PULocationID", public.zone."Zone"
FROM public.green_taxi_data
JOIN public.zone
ON public.green_taxi_data."PULocationID" = public.zone."LocationID"
WHERE public.green_taxi_data."PULocationID" = 112;
