-- models/marts/dim_products.sql
{{ config(materialized='table') }}

with latest_price as (
    -- latest positive price per stock_code from invoice lines
    select stock_code, unit_price as current_unit_price
    from (
        select
            stock_code,
            unit_price,
            invoice_ts,
            row_number() over (
                partition by stock_code
                order by invoice_ts desc nulls last
            ) as rn
        from {{ ref('stg_invoice_lines') }}
        where unit_price > 0
          and quantity > 0
    ) s
    where rn = 1
),
products as (
    -- one descriptive row per stock_code
    select distinct on (stock_code)
        stock_code,
        coalesce(nullif(trim(description), ''), 'Unknown') as description
    from {{ ref('stg_products') }}
    order by stock_code, description desc
)

select
    p.stock_code,
    p.description,
    lp.current_unit_price,
    {{ dbt_utils.generate_surrogate_key(['p.stock_code']) }} as product_sk
from products p
-- REQUIRE a price to exist
inner join latest_price lp
  on p.stock_code = lp.stock_code
