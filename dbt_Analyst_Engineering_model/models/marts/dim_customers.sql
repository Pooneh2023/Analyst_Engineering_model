-- models/marts/dim_customers.sql
{{ config(materialized='table') }}


select
    customer_id,
    country,
from base
where rn = 1
