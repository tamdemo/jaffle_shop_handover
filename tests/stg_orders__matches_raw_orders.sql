-- stg_orders must be 1:1 with the raw_orders seed (same id set, no drops or duplicates)
with stg as (
    select order_id from {{ ref('stg_orders') }}
),

raw as (
    select id as order_id from {{ ref('raw_orders') }}
),

missing_in_stg as (
    select order_id, 'missing_in_stg_orders' as issue from raw
    except
    select order_id, 'missing_in_stg_orders' from stg
),

extra_in_stg as (
    select order_id, 'not_in_raw_orders' as issue from stg
    except
    select order_id, 'not_in_raw_orders' from raw
),

row_count_mismatch as (
    select null as order_id, 'row_count_mismatch' as issue
    where (select count(*) from stg) != (select count(*) from raw)
)

select * from missing_in_stg
union all
select * from extra_in_stg
union all
select * from row_count_mismatch
