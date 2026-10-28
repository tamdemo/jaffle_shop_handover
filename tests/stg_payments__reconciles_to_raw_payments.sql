-- Cents -> dollars conversion must preserve row count and total amount vs raw_payments.
with staged as (

    select
        count(*) as row_count,
        coalesce(sum(amount), 0) * 100 as total_cents
    from {{ ref('stg_payments') }}

),

raw as (

    select
        count(*) as row_count,
        coalesce(sum(amount), 0) as total_cents
    from {{ ref('raw_payments') }}

)

select
    staged.row_count as staged_row_count,
    raw.row_count as raw_row_count,
    staged.total_cents as staged_total_cents,
    raw.total_cents as raw_total_cents
from staged
cross join raw
where staged.row_count != raw.row_count
    or abs(staged.total_cents - raw.total_cents) > 0.001
