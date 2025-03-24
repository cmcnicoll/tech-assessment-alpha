with
    receipts as (select * from {{ ref("stg_alpha__receipts") }}),

    receipt_items as (select * from {{ ref("stg_alpha__receipt_items") }}),

    users as (select * from {{ ref("stg_alpha__users") }}),

    brands as (select * from {{ ref("stg_alpha__brands") }}),

    joined as (

        select
            coalesce(brands.brand_id, tmp.brand_id) as brand_id,
            coalesce(brands.cpg_id, tmp.cpg_id) as cpg_id,
            coalesce(brands.brand_name, tmp.brand_name, '(Unknown)') as brand_name,
            coalesce(
                brands.brand_code, receipt_items.brand_code, '(No Code)'
            ) as brand_code,
            coalesce(
                brands.brand_category, tmp.brand_category, '(Unknown)'
            ) as brand_category,
            coalesce(
                brands.brand_category_code, tmp.brand_category_code, '(Unknown)'
            ) as brand_category_code,
            coalesce(receipt_items.barcode, '(No Code)') as barcode,
            coalesce(brands.cpg_ref, tmp.cpg_ref) as cpg_ref,
            coalesce(brands.is_top_brand, tmp.is_top_brand, false) as is_top_brand,

            receipts.user_id,
            coalesce(users.user_role, '(Unknown)') as user_role,
            coalesce(users.sign_up_source, '(Unknown)') as sign_up_source,
            coalesce(users.sign_up_state, '(Unknown)') as sign_up_state,
            coalesce(users.is_active_user, false) as is_active_user,
            users.user_created_at,
            users.user_last_login_at,

            receipts.* exclude (user_id, data_load_key, data_load_id),

            receipt_items.* exclude (
                parent_data_load_key, brand_code, barcode, is_deleted
            )

        from receipts

        left join
            receipt_items
            on (receipts.data_load_key = receipt_items.parent_data_load_key)
        left join users on (receipts.user_id = users.user_id)
        left join brands on (receipt_items.barcode = brands.barcode)

        -- temp workaround for missing barcodes
        left join
            brands as tmp
            on (receipt_items.brand_code = tmp.brand_code)
            and (tmp.brand_code_rank = 1)

    )

select *
from joined
