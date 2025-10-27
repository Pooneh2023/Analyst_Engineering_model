-- models/intermediate/prep_products.sql
{{ config(materialized='table') }}

with cleaned as (
  select
    stock_code,
    description,
    unit_price
  from {{ ref('stg_products') }}
  where unit_price is not null
    and unit_price > 0            -- drop zero/negative prices
)
select distinct on (stock_code)
  stock_code,
  description,
  unit_price
from cleaned
order by stock_code, unit_price desc
