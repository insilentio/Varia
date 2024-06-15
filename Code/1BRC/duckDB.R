library(duckdb)
library(stringr)

process_file_duckdb <- function(file_name) {
  con = dbConnect(duckdb())
  
  df <- dbGetQuery(con,
                   str_glue("SELECT
                              station_name,
                              min(measurement) as min_measurement,
                              cast(avg(measurement) as decimal(8, 1)) as mean_measurement,
                              max(measurement) as max_measurement
                            FROM read_csv(
                              '{file_name}',
                              header=true,
                              delim=';',
                              parallel=true)
                            GROUP BY station_name
                            ORDER BY station_name"))
  dbDisconnect(con)   
 
  df |>
    mutate(out = paste0(station_name, "=/", min_measurement, "/", mean_measurement, "/", max_measurement)) |> 
    pull(out) |>
    paste0(collapse = ", ")
}

# system.time(process_file_duckdb("Code/1BRC/measurements.txt"))
