## Analytics Engineering Template

This template helps apply [analytics engineering](https://www.getdbt.com/blog/what-is-analytics-engineering) best practices when working with raw data on your local machine, such as financial statements downloaded as CSV. It can also be used for technical assessments when interviewing for data jobs.

## Prerequisites
- [Docker Desktop](https://www.docker.com/)
- [VS Code](https://code.visualstudio.com/)
- Dev Containers extension (Identifier: `ms-vscode-remote.remote-containers`)
- Create an environment variable `LOCAL_DATA_PATH` for the path to the folder containing the raw data you want to load, transform, and analyze. This folder will be mounted to the dev container.

## Demo
1. Use this template to create a repository.
2. Clone your new repository.
3. Open the repository in VS Code.
4. **Reopen in Container**.
5. Open **View > Terminal**.
6. Run: ```make run```

## Original Inspiration
- [Modern Data Stack in a Box](https://duckdb.org/2022/10/12/modern-data-stack-in-a-box.html)
- [nba-monte-carlo](https://github.com/matsonj/nba-monte-carlo)

## Other Inspirations
- [dbt-labs/jaffle-shop](https://github.com/dbt-labs/jaffle-shop)
- [jwills/nba_monte_carlo](https://github.com/jwills/nba_monte_carlo)
- [l-mds/local-data-stack](https://github.com/l-mds/local-data-stack)

## Tools Used
- [dbt-core](https://github.com/dbt-labs/dbt-core)
- [dbt-duckdb](https://github.com/duckdb/dbt-duckdb)
- [dlt](https://github.com/dlt-hub/dlt)
- [duckdb](https://github.com/duckdb/duckdb)
- [harlequin](https://github.com/tconbeer/harlequin)
- [sqlfluff](https://github.com/sqlfluff/sqlfluff)
- [sqlfmt](https://github.com/tconbeer/sqlfmt)
- [vscode-dbt-power-user](https://github.com/AltimateAI/vscode-dbt-power-user)

## Entity Relationship Diagram

```mermaid
erDiagram
    USER {
        string user_id PK
        string data_load_key UK
        string user_role
        string sign_up_source
        string sign_up_state
        string data_load_id
        boolean is_active_user
        datetime user_created_at
        datetime user_last_login_at
    }

    BRAND {
        string barcode PK
        string brand_id UK
        string cpg_id
        string data_load_key UK
        string brand_name
        string brand_code
        string brand_category
        string brand_category_code
        string cpg_ref
        string data_load_id
        boolean is_top_brand
        int brand_code_rank
    }

    RECEIPT {
        string data_load_key PK
        string receipt_id UK
        string user_id FK
        string bonus_points_earned_reason
        string rewards_receipt_status
        string data_load_id
        decimal bonus_points_earned
        decimal total_points_earned
        int purchased_item_count
        decimal total_spent
        datetime receipt_created_at
        datetime receipt_scanned_at
        datetime receipt_finished_at
        datetime receipt_modified_at
        datetime receipt_points_awarded_at
        datetime receipt_purchased_at
    }

    RECEIPT_ITEM {
        string data_load_key PK
        string partner_item_id
        string points_payer_id
        string rewards_product_partner_id
        string parent_data_load_key FK
        string barcode FK
        string receipt_item_description
        string user_flagged_barcode
        string needs_fetch_review_reason
        string points_not_awarded_reason
        string rewards_group
        string user_flagged_description
        string original_meta_brite_barcode
        string original_meta_brite_description
        string brand_code FK
        string competitor_rewards_group
        string original_receipt_item_text
        string item_number
        string metabrite_campaign_id
        decimal final_price
        decimal item_price
        int quantity_purchased
        decimal user_flagged_price
        int user_flagged_quantity
        decimal discounted_item_price
        int original_meta_brite_quantity_purchased
        decimal points_earned
        decimal target_price
        decimal original_final_price
        decimal original_meta_brite_item_price
        decimal price_after_coupon
        int parent_data_load_index
        boolean is_review_required_by_fetch
        boolean is_target_gap_points_blocked
        boolean is_flagged_as_new_by_user
        boolean is_competitive_product
        boolean is_deleted
    }

    USER ||..o{ RECEIPT : "creates"
    RECEIPT ||--o{ RECEIPT_ITEM : "contains"
    BRAND ||..o{ RECEIPT_ITEM : "appears on"
```
