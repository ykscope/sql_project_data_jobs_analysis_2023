Select
    j.job_id,
    j.job_title,
    c.name as company_name,
    j.job_location,
    j.job_schedule_type,
    j.salary_year_avg,
    j.job_posted_date 
FROM job_postings_fact AS j
left JOIN company_dim as c on c.company_id = j.company_id
WHERE
    j.job_title_short = 'Data Analyst' AND
    j.job_location = 'Anywhere' AND
    j.salary_year_avg is NOT NULL
ORDER BY
    j.salary_year_avg DESC
LIMIT 10
