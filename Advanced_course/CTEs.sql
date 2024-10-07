WITH title_diversity AS (
    SELECT
        company_id,
        COUNT(DISTINCT job_title) AS unique_titles  
    FROM job_postings_fact
    GROUP BY company_id  
)
-- Get company name and count of how many unique titles each company has
SELECT
    company_dim.name,  
    title_diversity.unique_titles  
FROM title_diversity
	INNER JOIN company_dim ON title_diversity.company_id = company_dim.company_id  
ORDER BY 
	unique_titles DESC  
LIMIT 10;  


WITH avg_salaries AS (
  SELECT 
    job_country, 
    AVG(salary_year_avg) AS avg_salary
  FROM job_postings_fact
  GROUP BY job_country
)

SELECT
  -- Gets basic job info
	job_postings.job_id,
  job_postings.job_title,
  companies.name AS company_name,
  job_postings.salary_year_avg AS salary_rate,
-- categorizes the salary as above or below average the average salary for the country
  CASE
    WHEN job_postings.salary_year_avg > avg_salaries.avg_salary
    THEN 'Above Average'
    ELSE 'Below Average'
  END AS salary_category,
  -- gets the month and year of the job posting date
  EXTRACT(MONTH FROM job_postings.job_posted_date) AS posting_month
FROM
  job_postings_fact as job_postings
INNER JOIN
  company_dim as companies ON job_postings.company_id = companies.company_id
INNER JOIN
  avg_salaries ON job_postings.job_country = avg_salaries.job_country
ORDER BY
    -- Sorts it by the most recent job postings
    posting_month desc;

WITH required_skills AS (
  SELECT
    companies.company_id,
    COUNT(DISTINCT skills_to_job.skill_id) AS unique_skills_required
  FROM
    company_dim AS companies 
  LEFT JOIN job_postings_fact as job_postings ON companies.company_id = job_postings.company_id
  LEFT JOIN skills_job_dim as skills_to_job ON job_postings.job_id = skills_to_job.job_id
  GROUP BY
    companies.company_id
),
-- Gets the highest average yearly salary from the jobs that require at least one skills 
max_salary AS (
  SELECT
    job_postings.company_id,
    MAX(job_postings.salary_year_avg) AS highest_average_salary
  FROM
    job_postings_fact AS job_postings
  WHERE
    job_postings.job_id IN (SELECT job_id FROM skills_job_dim)
  GROUP BY
    job_postings.company_id
)
-- Joins 2 CTEs with table to get the query
SELECT
  companies.name,
  required_skills.unique_skills_required as unique_skills_required, --handle companies w/o any skills required
  max_salary.highest_average_salary
FROM
  company_dim AS companies
LEFT JOIN required_skills ON companies.company_id = required_skills.company_id
LEFT JOIN max_salary ON companies.company_id = max_salary.company_id
ORDER BY
	companies.name;