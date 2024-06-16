library(bench)

setwd(file.path(getwd(), "Code", "1BRC"))

source("R/baseRsingleThread.R")
source("R/baseRmultiThread.R")
source("R/baseRaggregate.R")
source("R/baseRtapply.R")
source("R/dplyr.R")
source("R/datatable.R")
source("R/duckDB.R")

filename <- "Data/measurements"

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
