-- orders is a left join from stg_orders; it must neither drop nor fan out rows.
-- Returns order_ids present in only one side, or duplicated in orders.

with orders as (
    select order_id, count(*) as n from {{ ref('orders') }} group by order_id
),

stg_orders as (
    select order_id, count(*) as n from {{ ref('stg_orders') }} group by order_id
)

select
    coalesce(orders.order_id, stg_orders.order_id) as order_id,
    orders.n as orders_rows,
    stg_orders.n as stg_orders_rows
from orders
full outer join stg_orders
    on orders.order_id = stg_orders.order_id
where orders.order_id is null
    or stg_orders.order_id is null
    or orders.n != stg_orders.n
