{{
  config(
    materialized='table'
  )
}}

with source as (
    select * from {{ source('raw', 'companies') }}
),

cleaned as (
    select
        company_id,
        name,
        company_url,
        description,
        staff_count,
        industries,
        logo_url,
        created_at,
        updated_at
    from source
    where name is not null  -- Filter out companies without names
)

select * from cleaned 