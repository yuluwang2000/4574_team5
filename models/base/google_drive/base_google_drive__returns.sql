SELECT _FILE,
       _LINE,
       _MODIFIED AS _MODIFIED_TS,
       _FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_TS,
       RETURNED_AT AS RETURNED_DATE,
       ORDER_ID,
       CASE IS_REFUNDED
            WHEN 'yes' THEN TRUE
            WHEN 'no' THEN FALSE
            END AS IS_REFUNDED
FROM {{source('google_drive','returns')}}