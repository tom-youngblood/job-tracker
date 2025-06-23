{{
  config(
    materialized='table'
  )
}}

with source as (
    select * from {{ source('raw', 'salaries') }}
),

cleaned as (
    select
        job_id,
        min_salary,
        max_salary,
        currency_code,
        created_at,
        updated_at
    from source
    where job_id is not null  -- Filter out salary records without job_id
)

select * from cleaned 