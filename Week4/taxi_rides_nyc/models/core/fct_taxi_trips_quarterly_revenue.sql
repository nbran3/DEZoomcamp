{{
    config(
        materialized='table'
    )
}}


with green_tripdata as (
    select *,
        'Green' as service_type
    from {{ ref('stg_green_taxidata') }}
),
yellow_tripdata as (
    select *,
        'Yellow' as service_type
    from {{ ref('stg_yellow_taxidata') }}
),
trips_unioned as (
    select * from green_tripdata
    union all
    select * from yellow_tripdata
)


SELECT DATE_TRUNC(trips_unioned.pickup_datetime, QUARTER) AS quarter_start, sum(total_amount) as revenue, service_type
from trips_unioned
group by service_type, 1
order by 1