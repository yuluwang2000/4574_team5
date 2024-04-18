SELECT session_id, item_name, item_view_at_ts, add_to_cart_quantity, remove_from_cart_quantity,(add_to_cart_quantity - remove_from_cart_quantity) AS Quantity,
CASE
    WHEN add_to_cart_quantity = 0 AND remove_from_cart_quantity = 0 THEN 'View'
    WHEN add_to_cart_quantity > 0 AND remove_from_cart_quantity = 0 THEN 'Add'
    WHEN add_to_cart_quantity > 0 AND remove_from_cart_quantity > 0 THEN 'Remove'
    ELSE 'other'
  END AS action_type
FROM {{ ref('base_snowflake__item_views') }}
ORDER BY 1, 6 DESC