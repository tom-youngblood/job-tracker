{{
  config(
    materialized='table'
  )
}}

with companies as (
    select * from {{ ref('stg_companies') }}
),

final as (
    select
        company_id,
        name as company_name,
        company_url,
        description as company_description,
        staff_count,
        industries,
        logo_url,
        created_at,
        updated_at
    from companies
)

select * from final 