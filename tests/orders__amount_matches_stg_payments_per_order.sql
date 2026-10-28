-- Per order, amount must equal the sum of that order's stg_payments.

with payments as (
    select order_id, sum(amount) as payments_amount
    from {{ ref('stg_payments') }}
    group by order_id
)

select
    orders.order_id,
    orders.amount,
    payments.payments_amount
from {{ ref('orders') }} as orders
left join payments
    on orders.order_id = payments.order_id
where abs(coalesce(orders.amount, 0) - coalesce(payments.payments_amount, 0)) > 0.001
