SELECT 
  s.seller_id,
  s.seller_state,
  COUNT(DISTINCT oi.order_id) AS num_orders,
  ROUND(SUM(oi.price), 2) AS total_revenue,
  ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM `olist-portfolio-project-506116.olist_ecommerce.order_items` oi
JOIN `olist-portfolio-project-506116.olist_ecommerce.sellers` s 
  ON oi.seller_id = s.seller_id
JOIN `olist-portfolio-project-506116.olist_ecommerce.orders` o 
  ON oi.order_id = o.order_id
JOIN `olist-portfolio-project-506116.olist_ecommerce.order_reviews` r 
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id, s.seller_state
HAVING num_orders > 50
ORDER BY total_revenue DESC
LIMIT 10;
