-- amount and every payment-method amount must be >= 0.

select
    order_id,
    amount,
    credit_card_amount,
    coupon_amount,
    bank_transfer_amount,
    gift_card_amount
from {{ ref('orders') }}
where amount < 0
    or credit_card_amount < 0
    or coupon_amount < 0
    or bank_transfer_amount < 0
    or gift_card_amount < 0
