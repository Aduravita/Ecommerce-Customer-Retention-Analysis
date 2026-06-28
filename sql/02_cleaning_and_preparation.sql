-- Convert order date columns from text to timestamp
CREATE TABLE clean.orders_v2 AS
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp::timestamp AS order_purchase_timestamp,
    order_approved_at::timestamp AS order_approved_at,
    order_delivered_carrier_date::timestamp AS order_delivered_carrier_date,
    order_delivered_customer_date::timestamp AS order_delivered_customer_date,
    order_estimated_delivery_date::timestamp AS order_estimated_delivery_date
FROM clean.orders;

-- Create order timing metrics
CREATE TABLE clean.orders_metrics AS
SELECT
    *,
    EXTRACT(EPOCH FROM (order_approved_at - order_purchase_timestamp))/86400 AS approval_days,
    EXTRACT(EPOCH FROM (order_delivered_carrier_date - order_approved_at))/86400 AS shipping_days,
    EXTRACT(EPOCH FROM (order_delivered_customer_date - order_purchase_timestamp))/86400 AS total_delivery_days,
    EXTRACT(EPOCH FROM (order_delivered_customer_date - order_estimated_delivery_date))/86400 AS delivery_delay_days
FROM clean.orders_v2;
