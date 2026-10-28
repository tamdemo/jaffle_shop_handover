-- customers.number_of_orders must equal the count of rows in orders for that customer
-- (customers with no orders are expected to have NULL, i.e. treated as 0 here).
with order_counts as (

    select customer_id, count(*) as expected_number_of_orders
    from {{ ref('orders') }}
    group by customer_id

)

select
    customers.customer_id,
    customers.number_of_orders,
    coalesce(order_counts.expected_number_of_orders, 0) as expected_number_of_orders
from {{ ref('customers') }} as customers
left join order_counts
    on customers.customer_id = order_counts.customer_id
where coalesce(customers.number_of_orders, 0) != coalesce(order_counts.expected_number_of_orders, 0)
