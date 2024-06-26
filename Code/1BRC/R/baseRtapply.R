# using base R with tapply

process_file_tapply <- function(file_name) {
  gc()
  
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
  
  res <- do.call("rbind", tapply(df$measurement, df$station_name, summarize))
  res <- data.frame(res)
  res$station_name <- row.names(res)
  row.names(res) <- NULL
  
  output <- ""
  for (i in 1:nrow(res)) {
    row <- res[i, ]
    output <- paste0(output, row$station_name, "=", sprintf("%.1f/%.1f/%.1f, ", row$min, row$mean, row$max))
  }
  output <- substr(output, 1, nchar(output) - 2)
  output
}

# system.time(process_file_tapply("Data/measurements"))
