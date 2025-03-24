with
    duplicate_barcodes as (

        select barcode, count(*) as barcode_count

        from {{ source("alpha", "brands") }}

        group by all

        having (barcode_count > 1)

    )

select *

from {{ source("alpha", "brands") }}

where (barcode in (select barcode from duplicate_barcodes))

order by barcode
