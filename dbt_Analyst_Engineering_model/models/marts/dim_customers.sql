-- models/marts/dim_customers.sql
{{ config(materialized='table') }}


select
    customer_id,
    country
from {{ ref('stg_customers') }}

