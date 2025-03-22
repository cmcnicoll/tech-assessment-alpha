with
    source as (
        select * from {{ source("alpha", "receipts__rewards_receipt_item_list") }}
    ),

    renamed as (

        select

            -- ids
            partner_item_id,
            points_payer_id,
            rewards_product_partner_id,
            _dlt_parent_id as parent_data_load_key,
            _dlt_id as data_load_key,

            -- strings
            coalesce(barcode, '(No Code)') as barcode,
            description as receipt_item_description,
            user_flagged_barcode,
            needs_fetch_review_reason,
            points_not_awarded_reason,
            rewards_group,
            user_flagged_description,
            original_meta_brite_barcode,
            original_meta_brite_description,
            coalesce(brand_code, '(No Code)') as brand_code,
            competitor_rewards_group,
            original_receipt_item_text,
            item_number,
            metabrite_campaign_id,

            -- numerics
            cast(final_price as decimal(18, 2)) as final_price,
            cast(item_price as decimal(18, 2)) as item_price,
            quantity_purchased,
            cast(user_flagged_price as decimal(18, 2)) as user_flagged_price,
            user_flagged_quantity,
            cast(discounted_item_price as decimal(18, 2)) as discounted_item_price,
            original_meta_brite_quantity_purchased,
            cast(points_earned as decimal(18, 2)) as points_earned,
            cast(target_price as decimal(18, 2)) as target_price,
            cast(original_final_price as decimal(18, 2)) as original_final_price,
            cast(
                original_meta_brite_item_price as decimal(18, 2)
            ) as original_meta_brite_item_price,
            cast(price_after_coupon as decimal(18, 2)) as price_after_coupon,
            _dlt_list_idx as parent_data_load_index,

            -- booleans
            coalesce(needs_fetch_review, false) as is_review_required_by_fetch,
            coalesce(prevent_target_gap_points, false) as is_target_gap_points_blocked,
            coalesce(user_flagged_new_item, false) as is_flagged_as_new_by_user,
            coalesce(competitive_product, false) as is_competitive_product,
            coalesce(deleted, false) as is_deleted

        from source

    )

select *
from renamed
