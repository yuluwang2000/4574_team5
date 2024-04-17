SELECT ITEM_NAME
       ,PRICE_PER_UNIT
FROM {{ ref('base_snowflake__item_views') }}
GROUP BY 1,2