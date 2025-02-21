{{
    config(
        materialized='table'
    )
}}


with fhvdata as (
    SELECT *
    from {{ref('stg_fhv_taxidata')}}
),
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
),


dim_fhv_base as (
    select *
    from fhvdata
    inner join dim_zones as pickup_zone
    on fhvdata.pulocationid = pickup_zone.locationid
),
fhv_data as(
select dispatching_base_num, 
pickup_datetime,
dropoff_datetime,
EXTRACT(YEAR FROM pickup_datetime) AS year,
EXTRACT(MONTH FROM pickup_datetime) AS month,
pulocationid,
dolocationid,
sr_flag,
affiliated_base_number,
locationid,
borough,
zone,
service_zone
from dim_fhv_base
)

select *
from fhv_data