-- customer_id must be an INTEGER (joined to stg_orders.customer_id downstream).
select customer_id, typeof(customer_id) as customer_id_type
from {{ ref('stg_customers') }}
where typeof(customer_id) <> 'INTEGER'
