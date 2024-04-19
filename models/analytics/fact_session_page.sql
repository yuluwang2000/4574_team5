SELECT *, 
ROW_NUMBER() OVER (PARTITION BY session_id ORDER BY VIEW_at_ts ASC) AS Rank
FROM {{ ref('int_session_page') }}
ORDER BY 1,4