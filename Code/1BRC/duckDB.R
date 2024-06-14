library(duckdb)
library(stringr)

process_file_duckdb <- function(file_name) {
  con = dbConnect(duckdb())
  
    df <- dbGetQuery(
    conn = con,
    statement = str_interp("
        select
            station_name,
            min(measurement) as min_measurement,
            cast(avg(measurement) as decimal(8, 1)) as mean_measurement,
            max(measurement) as max_measurement
        from read_csv(
            '${file_name}',
            header=false,
            columns={'station_name': 'varchar', 'measurement': 'decimal(8, 1)'},
            delim=';',
            parallel=true
        )
        group by station_name
        order by station_name
    ")
  )
  dbDisconnect(con)   
 
  output <- "{"
  for (i in 1:nrow(df)) {
    row <- df[i, ]
    output <- paste0(output, row$station_name, "=", sprintf("%.1f/%.1f/%.1f, ", row$min_measurement, row$mean_measurement, row$max_measurement))
  }
  output <- substr(output, 1, nchar(output) - 2)
  output <- paste0(output, "}")
  output
}

# system.time(process_file_duckdb("Code/1BRC/measurements.txt"))
