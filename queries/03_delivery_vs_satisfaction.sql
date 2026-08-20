SELECT 
  CASE 
    WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Late'
    ELSE 'On time or early'
  END AS delivery_status,
  ROUND(AVG(r.review_score), 2) AS avg_review_score,
  COUNT(*) AS num_orders
FROM `olist-portfolio-project-506116.olist_ecommerce.orders` o
JOIN `olist-portfolio-project-506116.olist_ecommerce.order_reviews` r 
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered' 
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;
