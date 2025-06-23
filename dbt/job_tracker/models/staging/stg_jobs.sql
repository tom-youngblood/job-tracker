{{
  config(
    materialized='table'
  )
}}

with source as (
    select * from {{ source('raw', 'jobs') }}
),

cleaned as (
    select
        job_id,
        job_title,
        job_url,
        location,
        remote_status,
        posted_at,
        job_type,
        is_easy_apply,
        description,
        employment_status,
        experience_level,
        is_remote_allowed,
        company_id,
        scrape_id,
        created_at,
        updated_at
    from source
    where job_title is not null  -- Filter out jobs without titles
)

select * from cleaned 