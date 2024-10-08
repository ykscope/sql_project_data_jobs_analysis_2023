with skills_demand as (
    SELECT 
        s.skill_id,
        s.skills,
        count ( ss.job_id ) as demand_count
    from job_postings_fact
    INNER JOIN skills_job_dim as ss on job_postings_fact.job_id = ss.job_id
    INNER JOIN skills_dim as s on ss.skill_id = s.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_work_from_home is TRUE    
        AND salary_year_avg is not NULL 
        
    Group BY
        s.skill_id
    ),
     average_salary as (SELECT 
    ss.skill_id,
    round (avg (salary_year_avg), 0) as avg_salary
from job_postings_fact
INNER JOIN skills_job_dim as ss on job_postings_fact.job_id = ss.job_id
INNER JOIN skills_dim as s on ss.skill_id = s.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg is not NULL 
    AND job_work_from_home is TRUE
Group BY
    ss.skill_id
    )

Select 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
from
    skills_demand
Inner join average_salary on skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
Limit 25