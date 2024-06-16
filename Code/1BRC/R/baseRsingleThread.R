process_file_single <- function(file_name) {
  gc()
  
  neutral_values <- c(100, -100, 0, 0)
  result <- new.env()
  con <- file(paste0(file_name, ".txt"), "r")
  
  while (length(line <- readLines(con, n = 1, warn = FALSE)) > 0) {
    parts <- strsplit(line, split = ";", fixed = TRUE)[[1]]
    station_name <- parts[1]
    measurement <- as.numeric(parts[2])
    
    values <- get0(station_name, result, ifnotfound = neutral_values)
    result[[station_name]] <- c(
      min(values[[1]], measurement),
      max(values[[2]], measurement),
      values[[3]] + measurement,
      values[[4]] + 1
    )
  }
  close(con)
  
  lines <- lapply(sort(names(result)), function(station_name) {
    values <- result[[station_name]]
    min_value <- values[[1]]
    max_value <- values[[2]]
    mean_value <- values[[3]] / values[[4]]
    sprintf("%s=%.1f/%.1f/%.1f", station_name, min_value, mean_value, max_value)
  })
  output <- paste(lines, collapse = ", ")
  output
}


# system.time(process_file_single("Data/measurements"))

