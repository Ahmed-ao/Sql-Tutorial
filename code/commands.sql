--* A query to set a time zone and then convert from it to a different time zone!
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date,
    TO_CHAR(
        DATE '2000-01-01' + (
            EXTRACT(
                MONTH
                FROM
                    job_posted_date
            ) - 1
        ) * INTERVAL '1 month',
        'Month'
    )
FROM
    job_postings_fact
LIMIT
    10;

--* A query to count job postings per month and through extracting the month from the date then group by the count itself.
SELECT
    COUNT(job_id) AS job_count,
    TO_CHAR(
        DATE '2000-01-01' + (
            EXTRACT(
                MONTH
                FROM
                    job_posted_date
            ) - 1
        ) * INTERVAL '1 month',
        'Month'
    ) AS Month
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    Month
ORDER BY
    job_count DESC
LIMIT
    10;

--* A query to find the average salary both yearly and hourly for a specific period of time grouped by a job schedule type(NOT SURE OF IT).
SELECT
    AVG(job_postings_fact.salary_year_avg),
    AVG(job_postings_fact.salary_hour_avg),
    job_schedule_type
FROM
    job_postings_fact
WHERE
    job_posted_date >= '2023-06-01' :: DATE
    AND job_title_short = 'Data Analyst'
GROUP BY
    job_schedule_type
ORDER BY
    job_schedule_type --* Create tables for the monthes of January, Februray and March
    CREATE TABLE january_jobs AS
SELECT
    *
FROM
    job_postings_fact
WHERE
    EXTRACT(
        MONTH
        FROM
            job_posted_date
    ) = 1;

-- Create table for February jobs
CREATE TABLE february_jobs AS
SELECT
    *
FROM
    job_postings_fact
WHERE
    EXTRACT(
        MONTH
        FROM
            job_posted_date
    ) = 2;

-- Create table for March jobs
CREATE TABLE march_jobs AS
SELECT
    *
FROM
    job_postings_fact
WHERE
    EXTRACT(
        MONTH
        FROM
            job_posted_date
    ) = 3;

SELECT
    *
FROM
    january_jobs
LIMIT
    5;

--* A query to sort Data Analyst jobs according to location
SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'Canada' THEN 'local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category
ORDER BY
    location_category DESC;

--* A query to show subquery concept
SELECT
    name AS company_name
FROM
    company_dim
WHERE
    company_id IN (
        SELECT
            company_id
        FROM
            job_postings_fact
        WHERE
            job_no_degree_mention = true
        ORDER BY
            company_id
    ) --* A query to sort out jobs per skills
    --! LOOK BACK AT ME
SELECT
    job_postings_fact.job_id,
    skill_id
FROM
    skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id --* A query combine UNION And UNION ALL
SELECT
    job_id,
    job_title_short
FROM
    january_jobsf
UNION
SELECT
    job_id,
    job_title_short
FROM
    february_jobs
UNION
ALL
SELECT
    job_id,
    job_title_short
FROM
    march_jobs