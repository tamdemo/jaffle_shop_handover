-- order_date must be a valid DATE and not later than today
select order_id, order_date
from {{ ref('stg_orders') }}
where try_cast(order_date as date) is null
   or cast(order_date as date) > current_date
