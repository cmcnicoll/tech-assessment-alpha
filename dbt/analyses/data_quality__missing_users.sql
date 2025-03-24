select *

from {{ source("alpha", "receipts") }}

where (user_id not in (select _id___oid from {{ source("alpha", "users") }}))

order by user_id
