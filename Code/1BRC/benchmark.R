library(bench)

source("Code/1BRC/baseRsingleThread.R")
source("Code/1BRC/baseRmultiThread.R")
source("Code/1BRC/baseRaggregate.R")
source("Code/1BRC/baseRtapply.R")
source("Code/1BRC/dplyr.R")
source("Code/1BRC/datatable.R")
source("Code/1BRC/duckDB.R")

filename <- "Code/1BRC/measurements.txt"

bm <- bench::mark(
        # single=process_file_single(filename),
        # multi=process_file_multi(filename),
        # aggregate=process_file_aggregate(filename),
        tapply=process_file_tapply(filename),
        dplyr=process_file_dplyr(filename),
        data.table=process_file_datatable(filename),
        DuckDB=process_file_duckdb(filename),
        iterations = 5,
        check = FALSE)

bm
plot(bm)

bm <- bench::mark(DuckDB=process_file_duckdb(filename),
            iterations = 10,
            check = FALSE)
