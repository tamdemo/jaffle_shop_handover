-- DuckDB `int / 100` yields DOUBLE (not integer division); guard against cents being truncated.
select
    payment_id,
    amount,
    typeof(amount) as amount_type
from {{ ref('stg_payments') }}
where typeof(amount) != 'DOUBLE'
