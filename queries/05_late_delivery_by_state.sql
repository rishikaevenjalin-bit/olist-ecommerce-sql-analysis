SELECT 
  c.customer_state,
  COUNT(*) AS total_orders,
  SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_orders,
  ROUND(100 * SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) / COUNT(*), 2) AS late_pct
FROM `olist-portfolio-project-506116.olist_ecommerce.orders` o
JOIN `olist-portfolio-project-506116.olist_ecommerce.customers` c 
  ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
HAVING COUNT(*) > 100
ORDER BY late_pct DESC
LIMIT 10;
