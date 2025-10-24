{{ config(materialized='table') }}

select
  stock_code,
  coalesce(nullif(description, ''), 'unknown') as description,
  unit_price
from {{ ref('stg_products') }}
where unit_price is not null
  and unit_price >= 0 -- remove invalid product prices
