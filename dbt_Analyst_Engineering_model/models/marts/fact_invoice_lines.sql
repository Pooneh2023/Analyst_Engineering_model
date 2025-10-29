-- models/marts/fact_invoice_lines.sql
{{ config(materialized='table') }}

with base as (
  select
    il.invoice_no,
    il.invoice_ts,
    il.customer_id,
    il.stock_code,
    il.quantity,
    il.unit_price,
    il.quantity * il.unit_price as line_amount
  from {{ ref('stg_invoice_lines') }} il
  -- SALES-ONLY: exclude returns and freebies
  where il.quantity > 0
    and il.unit_price > 0
),
joined as (
  select
    b.*,
    dp.stock_code ,
    dc.customer_id 
  from base b
  left join {{ ref('dim_products') }}  dp on b.stock_code  = dp.stock_code
  left join {{ ref('dim_customers') }} dc on b.customer_id = dc.customer_id
)
select * from joined
