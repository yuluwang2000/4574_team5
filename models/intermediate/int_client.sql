WITH table1 AS(
    SELECT s.client_id, s.session_id, o.client_name, s.session_at_ts, o.phone, o.state_name, o.iso_code,
    ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY session_at_ts ASC) AS rn
    FROM {{ ref('base_snowflake__sessions') }} as s
    JOIN {{ ref('base_snowflake__orders') }} as o
    ON o.session_id = s.session_id
    ORDER BY 1,4
)
SELECT client_id, client_name, phone, state_name, iso_code FROM table1
WHERE rn = 1
ORDER by client_id