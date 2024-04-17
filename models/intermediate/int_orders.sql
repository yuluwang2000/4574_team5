SELECT 
    s.CLIENT_ID, 
    iv.ITEM, 
    iv.ADD_TO_CART_QUANTITY, 
    iv.PRICE_PER_UNIT, 
    o.SESSION_ID, 
    o.ORDER_ID, 
    CASE 
        WHEN r.RETURNED_DATE IS NOT NULL THEN 1
        ELSE 0 
    END AS HAS_BEEN_RETURNED,
    r.RETURNED_DATE,
    r.IS_REFUNDED, 
    o.ISO_CODE, 
    o.SHIPPING_COST, 
    o.ORDER_AT_TS,   
    o.SHIPPING_ADDRESS, 
    o.STATE_NAME, 
    o.TAX_RATE
FROM 
    (SELECT *, ROW_NUMBER() OVER (PARTITION BY ORDER_ID ORDER BY ORDER_AT_TS) AS rn FROM {{ ref('base_snowflake__orders') }}) o
LEFT JOIN 
    {{ ref('base_snowflake__sessions') }} s ON o.SESSION_ID = s.SESSION_ID
INNER JOIN 
    {{ ref('base_snowflake__item_views') }} iv ON o.SESSION_ID = iv.SESSION_ID
LEFT JOIN 
    {{ ref('base_google_drive__returns') }} r ON o.ORDER_ID = r.ORDER_ID
WHERE
    o.rn = 1
