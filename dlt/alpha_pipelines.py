import dlt
import posixpath

from dlt.sources.filesystem import readers

DATA_BUCKET_URL = posixpath.abspath("../data/alpha/")
SOURCE_NAME = "alpha"
TABLE_NAMES = [
    "brands",
    "receipts",
    "users",
]


def read_jsonl_chunked(bucket_url: str, source_name: str, table_name: str) -> None:
    pipeline = dlt.pipeline(
        pipeline_name=f"{table_name}__read_files",
        destination=dlt.destinations.duckdb("../duckdb/raw_data.duckdb"),
        dataset_name=source_name,
    )

    json_files = readers(bucket_url, file_glob=f"{table_name}*.json*")
    json_data = json_files.read_jsonl(chunksize=10000)

    load_info = pipeline.run(
        json_data.with_name(table_name), write_disposition="replace"
    )
    print(load_info)
    print(pipeline.last_trace.last_normalize_info)


if __name__ == "__main__":
    for table_name in TABLE_NAMES:
        read_jsonl_chunked(DATA_BUCKET_URL, SOURCE_NAME, table_name)
