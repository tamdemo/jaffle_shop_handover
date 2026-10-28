-- amount must equal the sum of the four payment-method columns.

select
    order_id,
    amount,
    credit_card_amount,
    coupon_amount,
    bank_transfer_amount,
    gift_card_amount
from {{ ref('orders') }}
where abs(
    amount
    - (credit_card_amount + coupon_amount + bank_transfer_amount + gift_card_amount)
) > 0.001
