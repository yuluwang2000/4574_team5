SELECT 
    o.ORDER_ID,
    s.CLIENT_ID, 
    iv.ITEM_NAME, 
    iv.ADD_TO_CART_QUANTITY, 
    iv.REMOVE_FROM_CART_QUANTITY,
    (iv.ADD_TO_CART_QUANTITY - COALESCE(iv.REMOVE_FROM_CART_QUANTITY, 0)) AS ITEM_PURCHASED,
    iv.PRICE_PER_UNIT, 
    o.SESSION_ID
    
FROM 
    {{ ref('base_snowflake__orders') }} o
LEFT JOIN 
    {{ ref('base_snowflake__sessions') }} s ON o.SESSION_ID = s.SESSION_ID
INNER JOIN 
    {{ ref('base_snowflake__item_views') }} iv ON o.SESSION_ID = iv.SESSION_ID