SELECT 
  payment_type,
  COUNT(*) AS num_payments,
  ROUND(AVG(payment_installments), 2) AS avg_installments,
  ROUND(AVG(payment_value), 2) AS avg_payment_value,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM `olist-portfolio-project-506116.olist_ecommerce.order_payments`
GROUP BY payment_type
ORDER BY num_payments DESC;
