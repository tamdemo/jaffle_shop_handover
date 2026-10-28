-- stg_customers must be a 1:1 rename of raw_customers: no rows dropped, duplicated or invented.
with raw as (
    select id as customer_id, count(*) as n from {{ ref('raw_customers') }} group by 1
),

stg as (
    select customer_id, count(*) as n from {{ ref('stg_customers') }} group by 1
)

select
    coalesce(raw.customer_id, stg.customer_id) as customer_id,
    raw.n as raw_rows,
    stg.n as stg_rows
from raw
full outer join stg on raw.customer_id = stg.customer_id
where raw.n is distinct from stg.n
