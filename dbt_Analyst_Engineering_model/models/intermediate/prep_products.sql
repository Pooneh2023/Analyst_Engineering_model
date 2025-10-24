{{ config
    (
    materialized='table',
     partition_by = {
            'field': 'invoice_ts',
            'data_type': 'timestamp'
        },
    ) }}

select
    stock_code,
    coalesce(nullif(description, ''), 'unknown') as description,
    unit_price,
    price_updated_at  
from {{ ref('stg_products') }}
where unit_price is not null
  and unit_price >= 0  
