{{
    config(
        materialized='view'
    )
}}

with 

source as (

    select * from {{ source('staging', 'fhv_taxidata') }}
    where dispatching_base_num is not null

),

fhvdata as (

    select
        dispatching_base_num,
        cast(pickup_datetime as timestamp) as pickup_datetime,
        cast(dropoff_datetime as timestamp) as dropoff_datetime,
        cast(pulocationid as numeric) as pulocationid,
        cast(dolocationid as numeric) as dolocationid,
        sr_flag,
        affiliated_base_number

    from source

)

select * from fhvdata
