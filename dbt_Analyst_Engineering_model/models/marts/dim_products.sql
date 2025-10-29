-- models/marts/dim_products.sql
{{ config(materialized='table') }}


products as (
    -- one descriptive row per stock_code
    select distinct on (stock_code)
        stock_code,
        coalesce(nullif(trim(description), ''), 'Unknown') as description
    from {{ ref('stg_products') }}
    order by stock_code, description desc
)

select
    p.stock_code,
    p.description,
from products p

