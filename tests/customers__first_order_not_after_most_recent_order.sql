-- first_order (min order_date) must be on or before most_recent_order (max order_date).
select
    customer_id,
    first_order,
    most_recent_order
from {{ ref('customers') }}
where first_order > most_recent_order
