SELECT 
    o.ORDER_ID,
    s.CLIENT_ID,
    ARRAY_AGG(iv.ITEM) as ITEMS,
    SUM(iv.ADD_TO_CART_QUANTITY - COALESCE(iv.REMOVE_FROM_CART_QUANTITY, 0)) as TOTAL_QUANTITY,
    SUM((iv.ADD_TO_CART_QUANTITY - COALESCE(iv.REMOVE_FROM_CART_QUANTITY, 0)) * iv.PRICE_PER_UNIT) as TOTAL_PRICE,
    o.SESSION_ID,
    CASE 
        WHEN MAX(r.RETURNED_DATE) IS NOT NULL THEN 1
        ELSE 0 
    END AS HAS_BEEN_RETURNED,
    MAX(CASE WHEN r.IS_REFUNDED IS NOT NULL THEN 1 ELSE 0 END) AS IS_REFUNDED,
    o.CLIENT_NAME, 
    o.ISO_CODE, 
    o.SHIPPING_COST, 
    o.ORDER_AT_TS, 
    o.PAYMENT_INFO, 
    o.PAYMENT_METHOD, 
    o.PHONE, 
    o.SHIPPING_ADDRESS, 
    o.STATE_NAME, 
    o.TAX_RATE
FROM 
    {{ ref('base_snowflake__orders') }} o
LEFT JOIN 
    {{ ref('base_snowflake__sessions') }} s ON o.SESSION_ID = s.SESSION_ID
INNER JOIN 
    {{ ref('base_snowflake__item_views') }} iv ON o.SESSION_ID = iv.SESSION_ID
LEFT JOIN 
    {{ ref('base_google_drive__returns') }} r ON o.ORDER_ID = r.ORDER_ID
GROUP BY 
    s.CLIENT_ID,
    o.SESSION_ID, 
    o.ORDER_ID, 
    o.CLIENT_NAME, 
    o.ISO_CODE, 
    o.SHIPPING_COST, 
    o.ORDER_AT_TS, 
    o.PAYMENT_INFO, 
    o.PAYMENT_METHOD, 
    o.PHONE, 
    o.SHIPPING_ADDRESS, 
    o.STATE_NAME, 
    o.TAX_RATE