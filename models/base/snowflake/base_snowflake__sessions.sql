SELECT
    IP,
    OS,
    CLIENT_ID,
    SESSION_AT_TS,
    SESSION_ID,
    _FIVETRAN_DELETED,
    _FIVETRAN_ID,
    _FIVETRAN_SYNCED_TS
FROM (
    SELECT
        IP,
        OS,
        CAST(CLIENT_ID AS STRING) AS CLIENT_ID,
        SESSION_AT AS SESSION_AT_TS,
        SESSION_ID,
        _FIVETRAN_DELETED,
        _FIVETRAN_ID,
        _FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_TS,
        ROW_NUMBER() OVER (PARTITION BY SESSION_ID ORDER BY SESSION_AT) AS rn
    FROM
        {{ source('snowflake','sessions')}}
) AS sessions_with_rank
WHERE rn = 1