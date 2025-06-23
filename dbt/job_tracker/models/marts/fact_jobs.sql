{{
  config(
    materialized='table'
  )
}}

with jobs as (
    select * from {{ ref('stg_jobs') }}
),

companies as (
    select * from {{ ref('dim_companies') }}
),

salaries as (
    select * from {{ ref('stg_salaries') }}
),

application_status as (
    select * from {{ ref('stg_application_status') }}
),

final as (
    select
        j.job_id,
        j.job_title,
        j.job_url,
        j.location,
        j.remote_status,
        j.posted_at,
        j.job_type,
        j.is_easy_apply,
        j.description,
        j.employment_status,
        j.experience_level,
        j.is_remote_allowed,
        j.company_id,
        c.company_name,
        c.staff_count,
        c.industries,
        s.min_salary,
        s.max_salary,
        s.currency_code,
        aps.status as application_status,
        aps.notes as application_notes,
        aps.last_updated as status_last_updated,
        j.scrape_id,
        j.created_at,
        j.updated_at
    from jobs j
    left join companies c on j.company_id = c.company_id
    left join salaries s on j.job_id = s.job_id
    left join application_status aps on j.job_id = aps.job_id
)

select * from final 