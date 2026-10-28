-- When present, number_of_orders must be >= 1 (customers without orders are NULL, not 0).
select
    customer_id,
    number_of_orders
from {{ ref('customers') }}
where number_of_orders is not null
  and number_of_orders < 1
