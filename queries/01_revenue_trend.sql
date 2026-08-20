SELECT 
  EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
  EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
  ROUND(SUM(price), 2) AS total_revenue,
  COUNT(DISTINCT order_id) AS num_orders
FROM `olist-portfolio-project-506116.olist_ecommerce.orders_clean`
WHERE order_status = 'delivered'
GROUP BY year, month
ORDER BY year, month;
