WITH table1 AS(
SELECT s.SESSION_ID
     -- ,STRING_AGG(DISTINCT o.ORDER_ID,',') as ORDER_ID
      ,LISTAGG(DISTINCT o.ORDER_ID, ', ') WITHIN GROUP (ORDER BY o.ORDER_ID) AS ORDER_ID
      ,COUNT(DISTINCT CASE WHEN o.ORDER_ID IS NULL THEN NULL
             ELSE o.ORDER_ID
             END) AS ORDER_NUM
     -- ,o.ORDER_ID
      ,s.CLIENT_ID
      ,s.IP
      ,s.OS
      ,s.SESSION_AT_TS
      ,CASE WHEN MAX(i.ITEM_VIEW_AT_TS)>MAX(p.VIEW_AT_TS) THEN MAX(i.ITEM_VIEW_AT_TS)
            ELSE MAX(p.VIEW_AT_TS)
            END AS SESSION_END_TS
FROM {{ ref('base_snowflake__sessions') }} s
LEFT JOIN {{ ref('base_snowflake__orders') }} o ON o.SESSION_ID = s.SESSION_ID
LEFT JOIN {{ ref('base_snowflake__item_views') }} i ON i.SESSION_ID = s.SESSION_ID
LEFT JOIN {{ ref('base_snowflake__page_views') }}     p ON p.SESSION_ID = s.SESSION_ID
GROUP BY 1,4,5,6,7
),
table2 AS(
SELECT SESSION_ID
      ,COUNT(DISTINCT CASE WHEN PAGE_NAME ='shop_plants' THEN VIEW_AT_TS END) AS SHOP_PLANTS_PAGE_COUNT
      ,COUNT(DISTINCT CASE WHEN PAGE_NAME ='cart' THEN  VIEW_AT_TS END) AS CART_PAGE_COUNT
      ,COUNT(DISTINCT CASE WHEN PAGE_NAME ='faq' THEN  VIEW_AT_TS END) AS FAQ_PAGE_COUNT
      ,COUNT(DISTINCT CASE WHEN PAGE_NAME ='plant_care' THEN  VIEW_AT_TS END) AS PLANT_CARE_PAGE_COUNT
      ,COUNT(DISTINCT CASE WHEN PAGE_NAME ='landing_page' THEN VIEW_AT_TS END) AS LANDING_PAGE_PAGE_COUNT
FROM {{ ref('base_snowflake__page_views') }}    
GROUP BY 1
),
table3 AS(
SELECT SESSION_ID
      ,COUNT(ITEM_NAME) ITEM_COUNT
FROM  {{ ref('base_snowflake__item_views') }} 
GROUP BY 1
)
SELECT t1.*
      ,COALESCE(t2.SHOP_PLANTS_PAGE_COUNT,0)  SHOP_PLANTS_PAGE_COUNT
      ,COALESCE(t2.CART_PAGE_COUNT,0)  CART_PAGE_COUNT
      ,COALESCE(t2.FAQ_PAGE_COUNT,0)  FAQ_PAGE_COUNT
      ,COALESCE(t2.PLANT_CARE_PAGE_COUNT,0)  PLANT_CARE_PAGE_COUNT
      ,COALESCE(t2.LANDING_PAGE_PAGE_COUNT,0)  LANDING_PAGE_PAGE_COUNT
      ,COALESCE(t3.ITEM_COUNT,0) ITEM_COUNT
FROM table1 t1
LEFT JOIN table2 t2 ON t1.SESSION_ID = t2.SESSION_ID
LEFT JOIN table3 t3 ON t1.SESSION_ID = t3.SESSION_ID