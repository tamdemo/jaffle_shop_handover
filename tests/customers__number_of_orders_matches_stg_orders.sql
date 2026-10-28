-- number_of_orders must equal the count of stg_orders rows per customer.
with expected as (
    select customer_id, count(*) as expected_orders
    from {{ ref('stg_orders') }}
    group by customer_id
)

select
    c.customer_id,
    c.number_of_orders,
    e.expected_orders
from {{ ref('customers') }} as c
left join expected as e
    on c.customer_id = e.customer_id
where coalesce(c.number_of_orders, 0) != coalesce(e.expected_orders, 0)
