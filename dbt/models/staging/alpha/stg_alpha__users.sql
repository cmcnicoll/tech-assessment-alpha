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
            active as is_active_user,

            -- timestamps
            epoch_ms(created_date___date) as user_created_at,
            epoch_ms(last_login___date) as user_last_login_at

        from source

        -- remove duplicates
        qualify
            (
                row_number() over (
                    partition by user_id
                    order by user_last_login_at desc, user_created_at, data_load_key
                )
                = 1
            )

    )

select *
from renamed
