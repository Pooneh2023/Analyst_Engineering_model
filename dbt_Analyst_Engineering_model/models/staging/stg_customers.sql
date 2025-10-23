-- models/staging/stg_customers.sql
{{ config(materialized='view') }}

select distinct on (customer_id)
  customer_id,
  country
from {{ ref('stg_invoices') }}
where customer_id is not null
order by customer_id, invoice_ts desc, (country is null)
