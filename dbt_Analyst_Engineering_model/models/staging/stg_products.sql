-- models/staging/stg_products.sql
{{ config(materialized='view') }}

with ranked as (
  select
    stock_code,
    description,
    unit_price,
    invoice_ts,
    row_number() over (partition by stock_code order by invoice_ts desc) as rn
  from {{ ref('stg_invoices') }}
  where stock_code is not null
)
select stock_code, description, unit_price
from ranked
where rn = 1
