process_file_aggregate <- function(file_name) {
  df <- read.delim(
    file = paste0(file_name, ".txt"),
    header = TRUE,
    sep = ";",
    col.names = c("station_name", "measurement")
  )
  
  summarize <- function(x) {
    c(
      min = min(x),
      mean = mean(x),
      max = max(x)
    )
  }
  
  res <- aggregate(measurement ~ station_name, data = df, FUN = summarize)
  res <- do.call(data.frame, res)
  
  output <- ""
  for (i in 1:nrow(res)) {
    row <- res[i, ]
    output <- paste0(output, row$station_name, "=", sprintf("%.1f/%.1f/%.1f, ", row$measurement.min, row$measurement.mean, row$measurement.max))
  }
  output <- substr(output, 1, nchar(output) - 2)
  output
}


# system.time(process_file_aggregate("Code/1BRC/measurements.txt"))