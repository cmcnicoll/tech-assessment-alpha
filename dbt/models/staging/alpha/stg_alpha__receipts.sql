with
    source as (select * from {{ source("alpha", "receipts") }}),

    renamed as (

        select

            -- ids
            _id___oid as receipt_id,
            user_id,
            _dlt_id as data_load_key,

            -- strings
            coalesce(
                bonus_points_earned_reason, '(No Reason)'
            ) as bonus_points_earned_reason,
            rewards_receipt_status,
            _dlt_load_id as data_load_id,

            -- numerics
            cast(bonus_points_earned as decimal(18, 2)) as bonus_points_earned,
            cast(points_earned as decimal(18, 2)) as total_points_earned,
            purchased_item_count,
            cast(total_spent as decimal(18, 2)) as total_spent,

            -- timestamps
            epoch_ms(create_date___date) as receipt_created_at,
            epoch_ms(date_scanned___date) as receipt_scanned_at,
            epoch_ms(finished_date___date) as receipt_finished_at,
            epoch_ms(modify_date___date) as receipt_modified_at,
            epoch_ms(points_awarded_date___date) as receipt_points_awarded_at,
            epoch_ms(purchase_date___date) as receipt_purchased_at

        from source

    )

select *
from renamed
