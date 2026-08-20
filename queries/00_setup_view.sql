CREATE VIEW `olist-portfolio-project-506116.olist_ecommerce.orders_clean` AS
SELECT 
  o.order_id,
  o.customer_id,
  o.order_status,
  o.order_purchase_timestamp,
  o.order_delivered_customer_date,
  o.order_estimated_delivery_date,
  oi.product_id,
  oi.price,
  oi.freight_value,
  t.string_field_1 AS category
FROM `olist-portfolio-project-506116.olist_ecommerce.orders` o
JOIN `olist-portfolio-project-506116.olist_ecommerce.order_items` oi 
  ON o.order_id = oi.order_id
JOIN `olist-portfolio-project-506116.olist_ecommerce.products` p 
  ON oi.product_id = p.product_id
LEFT JOIN `olist-portfolio-project-506116.olist_ecommerce.category_translation` t 
  ON p.product_category_name = t.string_field_0;
