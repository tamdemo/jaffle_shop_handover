-- customer_lifetime_value must equal sum(orders.amount) for the customer
-- (customers and orders are both built from stg_payments; tolerance 0.001).
with expected as (
    select customer_id, sum(amount) as expected_value
    from {{ ref('orders') }}
    group by customer_id
)

select
    c.customer_id,
    c.customer_lifetime_value,
    e.expected_value
from {{ ref('customers') }} as c
left join expected as e
    on c.customer_id = e.customer_id
where abs(coalesce(c.customer_lifetime_value, 0) - coalesce(e.expected_value, 0)) > 0.001
