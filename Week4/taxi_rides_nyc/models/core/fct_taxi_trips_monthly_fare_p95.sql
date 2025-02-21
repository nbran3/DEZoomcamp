WITH green_tripdata AS (
    SELECT *, 
        'Green' AS service_type
    FROM {{ ref('stg_green_taxidata') }}
),
yellow_tripdata AS (
    SELECT *, 
        'Yellow' AS service_type
    FROM {{ ref('stg_yellow_taxidata') }}
),
trips_unioned AS (
    SELECT * FROM green_tripdata
    UNION ALL
    SELECT * FROM yellow_tripdata
),

filtered_data AS (
  SELECT
    service_type,
    fare_amount,
    trip_distance,
    payment_type_description
  FROM trips_unioned
  WHERE
    fare_amount > 0
    AND trip_distance > 0
    AND service_type = "Green"
    AND lower(payment_type_description) in ('cash', 'credit card')
    AND DATE(pickup_datetime) BETWEEN '2020-04-01' AND '2020-04-30'
)
SELECT
  service_type,
  PERCENTILE_CONT(fare_amount, 0.97) OVER(PARTITION by service_type) AS `p97`,
  PERCENTILE_CONT(fare_amount, 0.95) OVER(PARTITION by service_type) AS `p95`,
  PERCENTILE_CONT(fare_amount, 0.90) OVER(PARTITION by service_type) AS `p90`,
FROM filtered_data


