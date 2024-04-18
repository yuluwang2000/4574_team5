SELECT session_id, page_name, view_at_ts
FROM {{ ref('base_snowflake__page_views') }}
GROUP BY 1, 2, 3
ORDER BY 1, 3