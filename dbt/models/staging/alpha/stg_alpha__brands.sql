with
    source as (select * from {{ source("alpha", "brands") }}),

    renamed as (

        select

            -- ids
            _id___oid as brand_id,
            cpg___id___oid as cpg_id,
            barcode,
            _dlt_id as data_load_key,

            -- strings
            name as brand_name,
            coalesce(brand_code, '(No Code)') as brand_code,
            coalesce(category, '(No Category)') as brand_category,
            coalesce(category_code, '(No Code)') as brand_category_code,
            cpg___ref as cpg_ref,
            _dlt_load_id as data_load_id,

            -- booleans
            coalesce(top_brand, false) as is_top_brand,

            -- temp workaround for missing barcodes
            row_number() over (
                partition by brand_code  --
                order by is_top_brand desc, brand_id asc
            ) as brand_code_rank

        from source

        -- remove duplicates
        qualify
            (
                row_number() over (
                    partition by barcode  --
                    order by is_top_brand desc, brand_id asc
                )
                = 1
            )

    )

select *
from renamed
