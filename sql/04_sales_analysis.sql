-- Order-level revenue
CREATE TABLE analytics.order_sales AS
SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    SUM(p.payment_value::numeric) AS order_revenue
FROM clean.orders_v2 o
LEFT JOIN raw.olist_order_payments_dataset p
ON o.order_id = p.order_id
GROUP BY
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp;

-- Sales KPIs
CREATE TABLE analytics.sales_kpis AS
SELECT
    COUNT(*) AS total_orders,
    SUM(order_revenue) AS total_revenue,
    AVG(order_revenue) AS average_order_value
FROM analytics.order_sales
WHERE order_status = 'delivered';

-- Category performance
CREATE TABLE analytics.category_performance AS
SELECT
    COALESCE(t.product_category_name_english, 'unknown') AS category,
    COUNT(DISTINCT oi.order_id) AS orders,
    SUM(oi.price::numeric) AS product_revenue,
    ROUND(SUM(oi.price::numeric) / COUNT(DISTINCT oi.order_id), 2) AS avg_order_value
FROM raw.olist_order_items_dataset oi
JOIN raw.olist_products_dataset p
ON oi.product_id = p.product_id
LEFT JOIN raw.product_category_name_translation t
ON p.product_category_name = t.product_category_name
GROUP BY COALESCE(t.product_category_name_english, 'unknown');
