

SELECT 
    skills,
    round (avg (salary_year_avg), 0) as average_salary
from job_postings_fact
INNER JOIN skills_job_dim as ss on job_postings_fact.job_id = ss.job_id
INNER JOIN skills_dim as s on ss.skill_id = s.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg is not NULL 
    AND job_work_from_home is TRUE
Group BY
    skills
ORDER BY
    average_salary DESC
limit 25