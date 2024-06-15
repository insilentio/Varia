library(data.table)

process_file_datatable <- function(file_name) {
  dt <- fread(paste0(file_name, ".txt"), sep = ";", col.names = c("station_name", "measurement"))
  dt_summary <- dt[, .(
    min_measurement = min(measurement),
    mean_measurement = mean(measurement),
    max_measurement = max(measurement)
  ),
  by = station_name
  ]
  
  setkey(dt_summary, station_name)
  
  output <- ""
  for (i in 1:nrow(dt_summary)) {
    row <- dt_summary[i, ]
    output <- paste0(
      output, row$station_name, "=",
      sprintf("%.1f/%.1f/%.1f, ", row$min_measurement, row$mean_measurement, row$max_measurement)
    )
  }
  output <- substr(output, 1, nchar(output) - 2)
  output
}

# system.time(process_file_datatable("Code/1BRC/measurements.txt"))
