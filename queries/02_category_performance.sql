SELECT 
  category,
  ROUND(SUM(price), 2) AS total_revenue,
  COUNT(DISTINCT order_id) AS num_orders,
  ROUND(AVG(price), 2) AS avg_item_price
FROM `olist-portfolio-project-506116.olist_ecommerce.orders_clean`
WHERE order_status = 'delivered'
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 15;
