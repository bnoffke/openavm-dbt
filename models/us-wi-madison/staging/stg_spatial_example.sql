{{ config(materialized='view') }}

/*
  Example model using spatial extension
  
  This demonstrates that spatial functions work.
  Update source to read from your shapefile or GeoParquet.
*/

with test_locations as (
    -- Sample data with coordinates
    select 1 as id, 'Location A' as name, 40.7128 as lat, -74.0060 as lon
    union all
    select 2, 'Location B', 34.0522, -118.2437
),

with_geometry as (
    select
        id,
        name,
        lat,
        lon,
        st_point(lon, lat) as geometry,
        st_astext(st_point(lon, lat)) as geometry_wkt
    from test_locations
)

select * from with_geometry

/*
  To read from shapefile (SFTP mounted):
  
  with source as (
      select * from st_read('~/sftp_data/geo/parcels.shp')
  ),
  
  processed as (
      select
          parcel_id,
          geometry,
          st_area(geometry) as area_sqft,
          st_astext(geometry) as geometry_wkt
      from source
      where st_isvalid(geometry)
  )
  
  select * from processed
*/
