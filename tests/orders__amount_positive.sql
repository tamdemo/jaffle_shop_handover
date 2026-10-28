-- data issue flagged during handover review
-- Orders whose total paid amount is 0 (an order with only zero-value payments). Not fixed; surfaced for the client.
{{ config(severity='warn') }}

select order_id, customer_id, order_date, status, amount
from {{ ref('orders') }}
where amount <= 0
