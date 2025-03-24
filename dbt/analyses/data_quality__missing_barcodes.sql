select *

from {{ source("alpha", "receipts__rewards_receipt_item_list") }}

where (barcode not in (select barcode from {{ source("alpha", "brands") }}))

order by barcode
