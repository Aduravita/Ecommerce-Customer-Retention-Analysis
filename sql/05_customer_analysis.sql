-- Customer-level sales
CREATE TABLE analytics.customer_sales AS
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(p.payment_value::numeric) AS revenue
FROM raw.olist_customers_dataset c
JOIN clean.orders_v2 o
ON c.customer_id = o.customer_id
JOIN raw.olist_order_payments_dataset p
ON o.order_id = p.order_id
GROUP BY c.customer_unique_id;

-- Purchase frequency
SELECT
    orders,
    COUNT(*) AS customers
FROM analytics.customer_sales
GROUP BY orders
ORDER BY orders;

-- Repeat customer rate
SELECT
    COUNT(*) FILTER (WHERE orders > 1) AS repeat_customers,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(*) FILTER (WHERE orders > 1) * 100.0 / COUNT(*),
        2
    ) AS repeat_rate
FROM analytics.customer_sales;
