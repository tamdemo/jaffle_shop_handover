-- Total revenue in orders must reconcile to total payments in stg_payments (no payments lost or duplicated).
with totals as (

    select
        (select coalesce(sum(amount), 0) from {{ ref('orders') }}) as orders_total,
        (select coalesce(sum(amount), 0) from {{ ref('stg_payments') }}) as payments_total

)

select *
from totals
where abs(orders_total - payments_total) > 0.001
