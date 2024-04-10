SELECT
    _FIVETRAN_ID,
    _FIVETRAN_DELETED,
    _FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_TS,
    SESSION_ID,
    ITEM_VIEW_AT AS ITEM_VIEW_AT_TS,
    ADD_TO_CART_QUANTITY,
    REMOVE_FROM_CART_QUANTITY,
    ITEM_NAME,
    PRICE_PER_UNIT,
    CONCAT(ITEM_NAME, '_', PRICE_PER_UNIT) AS ITEM  
FROM {{ source('snowflake','item_views')}}