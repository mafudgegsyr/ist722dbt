with 
accounts as (
    select
        {{ dbt_utils.generate_surrogate_key(['account_id','snapshot_date']) }}  as accountkey,
        lat as account_lat,
        lon as account_lon
    from  {{ source('ffcu', 'accounts') }}
),
locations as (
    select
        {{ dbt_utils.generate_surrogate_key(['atm_id','snapshot_date']) }}  as locationkey,
        lat as location_lat,
        lon as location_lon
    from  {{ source('ffcu', 'locations') }}
),
transactions as (
    select
        tran_id,
        {{ dbt_utils.generate_surrogate_key(['account_id','tran_date']) }}  as accountkey,
        {{ dbt_utils.generate_surrogate_key(['atm_id','tran_date']) }}  as locationkey,
        tran_date,
        account_id,
        atm_id,
        case when type = 'W' then 'Withdrawl' else 'Deposit' end as Type,
        1 as transactions,
        case when type = 'W' then 1 else 0 end as Withdrawls,
        case when type = 'W' then 0 else 1 end as Deposits,
        case when type = 'W' then -1 * amount else amount end as Amount,
        Amount as PositiveAmount
    from {{ source('ffcu', 'transactions') }}
)
select  
    t.*,
    haversine(a.account_lat, a.account_lon, l.location_lat, l.location_lon) as distancetoatminkm
from transactions as t
    join accounts as a on a.accountkey = t.accountkey
    join locations as l on l.locationkey = t.locationkey
        