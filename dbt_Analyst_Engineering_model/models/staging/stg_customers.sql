-- models/staging/stg_customers.sql
{{ config(materialized='table') }}

select distinct on (customer_id)
  customer_id,
  country
from {{ ref('stg_invoices') }}
where customer_id is not null
