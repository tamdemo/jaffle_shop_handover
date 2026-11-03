-- Total customer_lifetime_value must reconcile to total stg_payments.amount
-- (no payments lost or double counted by the joins; tolerance 0.001).
with model_total as (
    select coalesce(sum(customer_lifetime_value), 0) as total from {{ ref('customers') }}
),

payments_total as (
    select coalesce(sum(amount), 0) as total from {{ ref('stg_payments') }}
)

select
    m.total as customers_total,
    p.total as payments_total
from model_total as m
cross join payments_total as p
where abs(m.total - p.total) > 0.001
