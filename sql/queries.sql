ALTER TABLE olist_orders_dataset
RENAME TO orders;

SELECT *
FROM orders
LIMIT 10;

SELECT 
    COUNT(*) AS total_orders
FROM orders;

SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

SELECT 
    strftime('%Y-%m', order_purchase_timestamp) AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;

ALTER TABLE olist_payments_dataset
RENAME TO order_payments;

SELECT 
    strftime('%Y-%m', o.order_purchase_timestamp) AS month,
    SUM(p.payment_value) AS revenue
FROM orders o
JOIN order_payments p
    ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;

SELECT 
    strftime('%Y-%m', o.order_purchase_timestamp) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(p.payment_value) AS revenue
FROM orders o
JOIN order_payments p
    ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;

SELECT 
    strftime('%Y-%m', o.order_purchase_timestamp) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(p.payment_value) AS revenue,
    SUM(p.payment_value) * 1.0 / COUNT(DISTINCT o.order_id) AS avg_order_value
FROM orders o
JOIN order_payments p
    ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;

SELECT 
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(p.payment_value) AS total_spent
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_payments p 
    ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;

SELECT 
    CASE 
        WHEN order_count = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS number_of_customers
FROM (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o 
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
GROUP BY customer_type;

SELECT 
    p.product_category_name,
    COUNT(*) AS total_items_sold
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_items_sold DESC
LIMIT 10;

SELECT 
    p.product_category_name,
    COUNT(*) AS total_items_sold
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_items_sold DESC
LIMIT 10;

SELECT 
    p.product_category_name,
    SUM(pmt.payment_value) AS revenue
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
JOIN order_payments pmt 
    ON oi.order_id = pmt.order_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;