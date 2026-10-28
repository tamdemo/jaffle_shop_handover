-- customers.first_order / most_recent_order must match min/max orders.order_date,
-- and first_order can never be after most_recent_order.
with order_dates as (

    select
        customer_id,
        min(order_date) as expected_first_order,
        max(order_date) as expected_most_recent_order
    from {{ ref('orders') }}
    group by customer_id

)

select
    customers.customer_id,
    customers.first_order,
    customers.most_recent_order,
    order_dates.expected_first_order,
    order_dates.expected_most_recent_order
from {{ ref('customers') }} as customers
left join order_dates
    on customers.customer_id = order_dates.customer_id
where customers.first_order is distinct from order_dates.expected_first_order
    or customers.most_recent_order is distinct from order_dates.expected_most_recent_order
    or customers.first_order > customers.most_recent_order
