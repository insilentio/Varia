library(bench)

source("Code/1BRC/baseRsingleThread.R")
source("Code/1BRC/baseRmultiThread.R")
source("Code/1BRC/baseRaggregate.R")
source("Code/1BRC/baseRtapply.R")
source("Code/1BRC/dplyr.R")
source("Code/1BRC/datatable.R")
source("Code/1BRC/duckDB.R")

filename <- "Code/1BRC/measurements"

bm <- bench::mark(
        # single = process_file_single(filename),
        # multi = process_file_multi(filename),
        # aggregate = process_file_aggregate(filename),
        # tapply = process_file_tapply(filename),
        dplyr = process_file_dplyr(filename),
        data.table = process_file_datatable(filename),
        DuckDB = process_file_duckdb(filename),
        dplyr_parquet = process_file_dplyr(filename, parquet = TRUE),
        DuckDB_parquet = process_file_duckdb(filename, parquet = TRUE),
        iterations = 3,
        check = FALSE,
        filter_gc = FALSE)

bm
plot(bm)
