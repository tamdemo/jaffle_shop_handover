-- Payment amounts must be non-negative (zero is allowed).
select
    payment_id,
    order_id,
    amount
from {{ ref('stg_payments') }}
where amount < 0
