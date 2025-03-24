with
    aggregate_by_brand_and_filter_by_user_created_at as (

        select
            brand_code,

            sum(final_price) as sum_final_price,
            count(distinct receipt_id) as receipt_count

        from {{ ref("fct_receipt_items") }}

        where
            (brand_code != '(No Code)')
            and (
                user_created_at
                > (select max(user_created_at) from {{ ref("fct_receipt_items") }})
                - interval '6 months'
            )

        group by all

    ),

    rank_brands as (

        select
            *,

            row_number() over (
                order by sum_final_price desc, brand_code
            ) as sum_final_price_rank,
            row_number() over (
                order by receipt_count desc, brand_code
            ) as receipt_count_rank

        from aggregate_by_brand_and_filter_by_user_created_at

    )

select
    brand_code, sum_final_price, sum_final_price_rank, receipt_count, receipt_count_rank

from rank_brands

where (sum_final_price_rank = 1) or (receipt_count_rank = 1)

order by all
