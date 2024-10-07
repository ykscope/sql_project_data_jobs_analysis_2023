SELECT
    job_schedule_type,
    avg (salary_year_avg) as avg_year_salary,
    avg (salary_hour_avg) as avg_hour_salary
FROM
    job_postings_fact
Where 
    job_posted_date >= '2023.06.01'
GROUP BY
    job_schedule_type
ORDER BY
    job_schedule_type; 


SELECT
    count (*) as vacancies,
    to_char ( job_posted_date at time zone 'UTC' at time zone 'EST', 'Mon') as month_num
FROM job_postings_fact
GROUP BY
    month_num,
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') 

ORDER BY
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST');


select
    c.name as company_name,
    count (distinct j.job_id) as vacancies
from job_postings_fact as j
inner join company_dim as c on j.company_id = c.company_id
Where
    EXTRACT (Quarter from j.job_posted_date) = 2 and
    j.job_health_insurance is true
GROUP by
    company_name
Having 
    count (distinct j.job_id) > 0
ORDER BY
    vacancies desc;