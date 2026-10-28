-- Every payment must land on an order: total orders.amount = total stg_payments.amount.

with orders_total as (
    select coalesce(sum(amount), 0) as total from {{ ref('orders') }}
),

payments_total as (
    select coalesce(sum(amount), 0) as total from {{ ref('stg_payments') }}
)

select
    orders_total.total as orders_total,
    payments_total.total as payments_total
from orders_total
cross join payments_total
where abs(orders_total.total - payments_total.total) > 0.001
