#!/bin/bash
for filename in $1/*.csv; do
    [ -e "$filename" ] || continue
    fullname="$(cd "$(dirname "$filename")"; pwd -P)/$(basename "$filename")"
    base=$(basename "$filename")
    base_noext=${base%.*}
    # clever mode, slower b/c inferring based on all lines
    $DUCKDB_PATH data_views_inferred.db "CREATE view $base_noext AS SELECT * from read_csv_auto('"$fullname"', SAMPLE_SIZE=-1)"
    # all as varchar, much faster
    $DUCKDB_PATH data_views_varchar.db "CREATE view $base_noext AS SELECT * from read_csv_auto('"$fullname"', ALL_VARCHAR=1)"
done

