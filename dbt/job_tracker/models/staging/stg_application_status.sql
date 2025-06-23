{{
  config(
    materialized='table'
  )
}}

with source as (
    select * from {{ source('raw', 'application_status') }}
),

cleaned as (
    select
        job_id,
        status,
        notes,
        last_updated,
        created_at,
        updated_at
    from source
    where job_id is not null  -- Filter out status records without job_id
)

select * from cleaned 