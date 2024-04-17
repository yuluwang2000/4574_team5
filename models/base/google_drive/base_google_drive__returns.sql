WITH table1 AS(
SELECT _FILE,
       _LINE,
       _MODIFIED AS _MODIFIED_TS,
       _FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_TS,
       RETURNED_AT AS RETURNED_DATE,
       ORDER_ID,
       RANK() OVER(PARTITION BY ORDER_ID ORDER BY RETURNED_AT) AS ra,
       CASE IS_REFUNDED
            WHEN 'yes' THEN TRUE
            WHEN 'no' THEN FALSE
            END AS IS_REFUNDED
FROM {{source('google_drive','returns')}}
)

SELECT _FILE,
       _LINE,
       _MODIFIED_TS,
       _FIVETRAN_SYNCED_TS,
       RETURNED_DATE,
       ORDER_ID,
       IS_REFUNDED
FROM table1
WHERE ra = 1




