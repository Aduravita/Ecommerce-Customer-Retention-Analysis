-- Check duplicate orders
SELECT order_id, COUNT(*)
FROM raw.olist_orders_dataset
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Check missing order fields
SELECT 
    COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_id,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_id,
    COUNT(*) FILTER (WHERE order_status IS NULL) AS missing_status
FROM raw.olist_orders_dataset;

-- Check missing delivery dates by status
SELECT 
    order_status,
    COUNT(*) AS missing_delivery_dates
FROM raw.olist_orders_dataset
WHERE order_delivered_customer_date IS NULL
GROUP BY order_status
ORDER BY missing_delivery_dates DESC;

-- Check orders without customers
SELECT COUNT(*)
FROM raw.olist_orders_dataset o
LEFT JOIN raw.olist_customers_dataset c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
