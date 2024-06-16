library(duckdb)
library(stringr)
library(arrow)

process_file_duckdb <- function(file_name, parquet = FALSE) {
  gc()
  
  con = dbConnect(duckdb())
  
  if (!parquet) {
    df <- dbGetQuery(con,
                     str_glue("SELECT
                                station_name,
                                min(measurement) as minm,
                                cast(avg(measurement) as decimal(8, 1)) as meanm,
                                max(measurement) as maxm,
                                concat(station_name, '=/', minm, '/', meanm, '/', maxm) as out
                              FROM read_csv(
                                '{file_name}.txt',
                                header=true,
                                delim=';',
                                parallel=true)
                              GROUP BY station_name
                              ORDER BY station_name"))
  } else {
    df <- dbGetQuery(con,
                     str_glue("SELECT
                                station_name,
                                min(measurement) as minm,
                                cast(avg(measurement) as decimal(8, 1)) as meanm,
                                max(measurement) as maxm,
                                concat(station_name, '=/', minm, '/', meanm, '/', maxm) as out
                              FROM read_parquet(
                                '{file_name}.parquet')
                              GROUP BY station_name
                              ORDER BY station_name"))
  }
  dbDisconnect(con)
 
  paste0(df$out, collapse = ", ")
}

system.time(process_file_duckdb("Data/measurements", parquet = TRUE))
