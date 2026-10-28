-- customers must have exactly one row per stg_customers row: the left joins to
-- customer_orders / customer_payments must not fan out or drop customers.
with model_ids as (
    select customer_id from {{ ref('customers') }}
),

source_ids as (
    select customer_id from {{ ref('stg_customers') }}
),

missing_or_extra as (
    select customer_id, 'missing_from_customers' as issue
    from (select customer_id from source_ids except select customer_id from model_ids)
    union all
    select customer_id, 'not_in_stg_customers' as issue
    from (select customer_id from model_ids except select customer_id from source_ids)
),

row_counts as (
    select
        null as customer_id,
        'row_count_mismatch' as issue
    where (select count(*) from model_ids) != (select count(*) from source_ids)
)

select * from missing_or_extra
union all
select * from row_counts
