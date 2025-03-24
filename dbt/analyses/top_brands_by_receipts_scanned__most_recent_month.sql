with
    count_receipts_by_brand_and_scanned_month as (

        select
            brand_code,
            strftime(receipt_scanned_at, '%Y-%m') as receipt_scanned_month,

            count(distinct receipt_id) as receipt_count

        from {{ ref("fct_receipt_items") }}

        where (brand_code != '(No Code)')

        group by all

    ),

    rank_brands_by_receipts_scanned_per_month as (

        select
            *,

            row_number() over (
                partition by receipt_scanned_month
                order by receipt_count desc, brand_code asc
            ) as brand_rank

        from count_receipts_by_brand_and_scanned_month

    ),

    look_backward as (

        select
            *,

            lag(brand_rank) over (
                partition by brand_code  --
                order by receipt_scanned_month
            ) as prev_brand_rank,
            lag(receipt_count) over (
                partition by brand_code  --
                order by receipt_scanned_month
            ) as prev_receipt_count

        from rank_brands_by_receipts_scanned_per_month

    )

select
    receipt_scanned_month,
    brand_code,
    brand_rank,
    receipt_count,
    prev_brand_rank,
    prev_receipt_count

from look_backward

where
    (brand_rank <= 5)
    and (
        receipt_scanned_month = (
            select max(receipt_scanned_month)
            from count_receipts_by_brand_and_scanned_month
        )
    )

order by brand_rank
