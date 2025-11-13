{{
  config(
    materialized='external',
    location='./output/parquet/example_output.parquet',
    format='parquet'
  )
}}

/*
  Example mart model with external parquet output
  
  This will create: output/parquet/example_output.parquet
*/

select 1 /*
    key,
    sale_date,
    sale_price,
    current_timestamp as exported_at
from 
*/