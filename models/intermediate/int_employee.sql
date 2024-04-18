SELECT j.EMPLOYEE_ID,
    HIRE_DATE,
    NAME,
    CITY,
    ADDRESS,
    TITLE,
    ANNUAL_SALARY,
    QUIT_DATE
FROM  {{ ref('base_google_drive__hr_joins') }} as j
LEFT JOIN  {{ ref('base_google_drive__hr_quits') }} as q
ON j.EMPLOYEE_ID = q.EMPLOYEE_ID