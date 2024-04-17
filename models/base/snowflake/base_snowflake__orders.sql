SELECT
    CLIENT_NAME, 
    ORDER_ID,
    ORDER_AT_TS,
    PAYMENT_INFO,
    PAYMENT_METHOD,
    PHONE,
    SESSION_ID,
    SHIPPING_ADDRESS,
    SHIPPING_COST,
    STATE_NAME,
    TAX_RATE,
    _FIVETRAN_DELETED,
    _FIVETRAN_ID,
    _FIVETRAN_SYNCED_TS,
    ISO_CODE
FROM (
    SELECT
        o.CLIENT_NAME, 
        o.ORDER_ID,
        o.ORDER_AT AS ORDER_AT_TS,
        o.PAYMENT_INFO,
        o.PAYMENT_METHOD,
        o.PHONE,
        o.SESSION_ID,
        o.SHIPPING_ADDRESS,
        CAST(SUBSTR(o.SHIPPING_COST, 4) AS INT) AS SHIPPING_COST,
        o.STATE AS STATE_NAME,
        o.TAX_RATE,
        o._FIVETRAN_DELETED,
        o._FIVETRAN_ID,
        o._FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_TS,
        s.ISO_CODE,
        ROW_NUMBER() OVER (PARTITION BY o.ORDER_ID ORDER BY o.ORDER_AT) AS rn
    FROM {{ source('snowflake','orders') }} o
    LEFT JOIN {{ source('public','STATE_ISO_CODES') }} s ON o.STATE = s.STATE_NAME
) AS orders_with_rank
WHERE orders_with_rank.rn = 1