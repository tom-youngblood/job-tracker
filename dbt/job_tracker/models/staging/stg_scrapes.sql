{{
  config(
    materialized='table'
  )
}}

with source as (
    select * from {{ source('raw', 'scrapes') }}
),

cleaned as (
    select
        scrape_id,
        run_at,
        search_keyword,
        location_id,
        jobs_found,
        created_at,
        updated_at
    from source
)

select * from cleaned 