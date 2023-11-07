{{
    config(
        materialized='incremental',
        unique_key='accountkey',
        incremental_strategy='merge'
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['account_id','snapshot_date']) }}  as accountkey,
    account_id,
    snapshot_date,
    name,
    address,
    lat,
    lon

from  {{ source('ffcu', 'accounts') }}
