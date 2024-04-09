SELECT
    ISO_CODE,
    STATE_NAME
FROM {{ source('public','STATE_ISO_CODES')}}