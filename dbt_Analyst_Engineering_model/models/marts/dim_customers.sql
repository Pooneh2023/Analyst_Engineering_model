-- models/marts/dim_customers.sql
{{ config(materialized='table') }}

with base as (
    select
        customer_id,
        country,
        row_number() over (partition by customer_id order by customer_id) as rn
    from {{ ref('stg_customers') }}
)
select
    customer_id,
    country,
    {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_sk
from base
where rn = 1
