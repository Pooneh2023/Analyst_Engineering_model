-- models/staging/stg_invoice_lines.sql
{{ config(materialized='view') }}

select
  invoice_no,
  invoice_ts,
  customer_id,
  stock_code,
  quantity,
  unit_price,
  quantity * unit_price as line_amount
from {{ ref('stg_invoices') }}
