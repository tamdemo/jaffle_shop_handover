-- customers.customer_lifetime_value must equal the sum of orders.amount for that customer.
with order_totals as (

    select customer_id, sum(amount) as expected_lifetime_value
    from {{ ref('orders') }}
    group by customer_id

)

select
    customers.customer_id,
    customers.customer_lifetime_value,
    order_totals.expected_lifetime_value
from {{ ref('customers') }} as customers
left join order_totals
    on customers.customer_id = order_totals.customer_id
where abs(coalesce(customers.customer_lifetime_value, 0) - coalesce(order_totals.expected_lifetime_value, 0)) > 0.001
