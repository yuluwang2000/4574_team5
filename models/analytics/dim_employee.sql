SELECT *,
    CASE WHEN QUIT_DATE IS NOT NULL THEN TRUE ELSE FALSE END as IS_QUIT,
FROM {{ ref('int_employee') }}