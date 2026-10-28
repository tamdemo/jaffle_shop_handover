-- Customers with at least one order in stg_orders must have non-null
-- first_order, most_recent_order, number_of_orders and customer_lifetime_value;
-- customers with no orders must have all four NULL (left join semantics).
with customers_with_orders as (
    select distinct customer_id from {{ ref('stg_orders') }}
)

select
    c.customer_id,
    c.first_order,
    c.most_recent_order,
    c.number_of_orders,
    c.customer_lifetime_value,
    o.customer_id is not null as has_orders
from {{ ref('customers') }} as c
left join customers_with_orders as o
    on c.customer_id = o.customer_id
where
    (
        o.customer_id is not null
        and (
            c.first_order is null
            or c.most_recent_order is null
            or c.number_of_orders is null
            or c.customer_lifetime_value is null
        )
    )
    or (
        o.customer_id is null
        and (
            c.first_order is not null
            or c.most_recent_order is not null
            or c.number_of_orders is not null
            or c.customer_lifetime_value is not null
        )
    )
