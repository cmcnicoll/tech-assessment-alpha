with
    duplicate_users as (

        select _id___oid as user_id, count(*) as user_count

        from {{ source("alpha", "users") }}

        group by all

        having (user_count > 1)

    )

select *

from {{ source("alpha", "users") }}

where (_id___oid in (select user_id from duplicate_users))

order by _id___oid
