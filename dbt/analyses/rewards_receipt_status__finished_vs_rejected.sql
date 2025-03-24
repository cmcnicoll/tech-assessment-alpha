with
    aggregate_to_receipt_level_and_filter_on_status as (

        select distinct
            receipt_id, rewards_receipt_status, purchased_item_count, total_spent

        from {{ ref("fct_receipt_items") }}

        where (rewards_receipt_status in ('FINISHED', 'REJECTED'))

    )

select
    rewards_receipt_status,

    avg(total_spent) as avg_total_spent,
    sum(purchased_item_count) as sum_purchased_item_count

from aggregate_to_receipt_level_and_filter_on_status

group by all
order by all
