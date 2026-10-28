-- data issue flagged during handover review
-- Payments recorded with an amount of 0. Not fixed; surfaced for the client.
{{ config(severity='warn') }}

select payment_id, order_id, payment_method, amount
from {{ ref('stg_payments') }}
where amount <= 0
