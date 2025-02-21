{{
    config(
        materialized='table'
    )
}}

WITH fhvdata AS (
    SELECT *
    FROM {{ ref('stg_fhv_taxidata') }}
),
dim_zones AS (
    SELECT *
    FROM {{ ref('dim_zones') }}
    WHERE borough != 'Unknown'
),
dim_fhv_base AS (
    SELECT *
    FROM fhvdata
    INNER JOIN dim_zones AS pickup_zone
    ON fhvdata.pulocationid = pickup_zone.locationid
),
fhv_data AS (
    SELECT
        dispatching_base_num, 
        pickup_datetime,
        dropoff_datetime,
        EXTRACT(YEAR FROM pickup_datetime) AS date_year,
        EXTRACT(MONTH FROM pickup_datetime) AS date_month,
        pulocationid,
        dolocationid,
        sr_flag,
        affiliated_base_number,
        locationid,
        borough,
        zone,
        TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) AS trip_duration,
        service_zone
    FROM dim_fhv_base
),
p90_trip_duration AS (
    SELECT
        pulocationid,
        dolocationid,
        percentile_cont(trip_duration, 0.9) OVER (PARTITION BY date_year, date_month, pulocationid, dolocationid) AS trip_p90
    FROM fhv_data
    WHERE DATE(pickup_datetime) BETWEEN '2019-11-01' AND '2019-11-30'
    AND pulocationid IN (1, 211, 262) -- Newark Airport, SoHo, Yorkville East
),
ranked_p90 AS (
    SELECT
        pulocationid,
        dolocationid,
        trip_p90,
        DENSE_RANK() OVER (PARTITION BY pulocationid ORDER BY trip_p90 DESC) AS p90_rank
    FROM p90_trip_duration
),
final_result AS (
    SELECT
        r.pulocationid,
        r.dolocationid,
        dz.zone AS dropoff_zone,
        r.trip_p90,
        r.p90_rank
    FROM ranked_p90 r
    INNER JOIN dim_zones dz
    ON r.dolocationid = dz.locationid
    WHERE r.p90_rank = 2 -- Filter for the 2nd longest p90 trip duration
)

SELECT *
FROM final_result
ORDER BY pulocationid, trip_p90 