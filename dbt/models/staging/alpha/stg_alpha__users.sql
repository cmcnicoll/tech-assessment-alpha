with
    source as (select * from {{ source("alpha", "users") }}),

    renamed as (

        select

            -- ids
            _id___oid as user_id,
            _dlt_id as data_load_key,

            -- strings
            role as user_role,
            coalesce(sign_up_source, '(No Source)') as sign_up_source,
            coalesce(state, '(No State)') as sign_up_state,
            _dlt_load_id as data_load_id,

            -- booleans
            active as is_active,

            -- timestamps
            epoch_ms(created_date___date) as created_at,
            epoch_ms(last_login___date) as last_login_at

        from source

        -- remove duplicates
        qualify
            (
                row_number() over (
                    partition by user_id order by last_login_at desc, data_load_key
                )
                = 1
            )

    )

select *
from renamed
