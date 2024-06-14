library(dplyr)

process_file_dplyr <- function(file_name) {
  df <- read.delim(
    file = file_name,
    header = FALSE,
    sep = ";",
    col.names = c("station_name", "measurement")
  ) %>%
    group_by(station_name) %>%
    summarise(
      min_measurement = min(measurement),
      mean_measurement = mean(measurement),
      max_measurement = max(measurement)
    ) %>%
    arrange(station_name)
  
  
  output <- "{"
  for (i in 1:nrow(df)) {
    row <- df[i, ]
    output <- paste0(output, row$station_name, "=", sprintf("%.1f/%.1f/%.1f, ", row$min_measurement, row$mean_measurement, row$max_measurement))
  }
  output <- substr(output, 1, nchar(output) - 2)
  output <- paste0(output, "}")
  output
}


# system.time(process_file_dplyr("Code/1BRC/measurements.txt"))
