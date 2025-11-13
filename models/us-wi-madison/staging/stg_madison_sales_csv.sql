{{ config(materialized='view') }}

with source as (
    select * from read_csv_auto('/home/bnoffke/data/openavm/raw/wi-sales/*CSV.csv',union_by_name=true)
),

cleaned as (
    select
        *
    from source
    where "TVCname" = 'MADISON, CITY OF'
)

select * from cleaned
