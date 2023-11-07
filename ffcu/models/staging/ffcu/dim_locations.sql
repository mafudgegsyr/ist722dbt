{{
    config(
        materialized='incremental',
        unique_key='locationkey',
        incremental_strategy='merge'
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['atm_id','snapshot_date']) }}  as locationkey,
    atm_id,
    snapshot_date,
    location,
    lat,
    lon

from {{ source('ffcu', 'locations') }}
