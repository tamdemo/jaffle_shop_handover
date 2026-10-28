-- orders must have exactly one row per stg_orders row (the payments join must not fan out or drop orders).
with counts as (

    select
        (select count(*) from {{ ref('orders') }}) as orders_rows,
        (select count(*) from {{ ref('stg_orders') }}) as stg_orders_rows

)

select *
from counts
where orders_rows != stg_orders_rows
