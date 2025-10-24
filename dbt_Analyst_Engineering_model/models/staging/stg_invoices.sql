{{ config(materialized='table') }}

with base as (
    select
        -- rename + cast
        i.invoices_no::text                  as invoice_no,
        nullif(trim(i.stock_code), '')       as stock_code,
        nullif(trim(i.describtion), '')      as description,  -- raw column misspelled
        i.quantity::integer                  as quantity,
        i.invoice_date::timestamp            as invoice_ts,
        i.unit_price::numeric(12,4)          as unit_price,
        i.customer_id::bigint                as customer_id,
        nullif(trim(i.country), '')          as country
    from {{ source('raw','invoices') }} i
)

select * from base
