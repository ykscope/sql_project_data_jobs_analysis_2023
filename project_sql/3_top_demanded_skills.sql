

SELECT 
    skills,
    count ( ss.job_id ) as demand_count
from job_postings_fact
INNER JOIN skills_job_dim as ss on job_postings_fact.job_id = ss.job_id
INNER JOIN skills_dim as s on ss.skill_id = s.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home is TRUE
Group BY
    skills
ORDER BY
    demand_count DESC
limit 10