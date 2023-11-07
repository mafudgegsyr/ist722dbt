{{
    config(
        materialized='incremental',
        unique_key='datekey',
        incremental_strategy='merge'
    )
}}


select
    datekey::int as datekey,
    date,
    datetime,
    year,
    quarter,
    quartername,
    month,
    monthname,
    day,
    dayofweek,
    dayname,
    weekday,
    weekofyear,
    dayofyear

from {{ source('ffcu', 'datedimension') }}
