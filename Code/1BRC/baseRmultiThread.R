library(foreach)
library(doParallel)

get_file_chunks <- function(file_name) {
  n_workers <- detectCores() - 1
  file_size <- file.info(file_name)$size
  chunk_size <- ceiling(file_size / n_workers)
  
  con <- file(file_name, "r")
  boundaries <- lapply(seq_len(n_workers - 1), function(i) {
    boundary <- i * chunk_size
    seek(con, boundary)
    line <- readLines(con, n = 1)
    boundary + nchar(line) + 1
  })
  close(con)
  
  boundaries <- c(0, boundaries, file_size)
  lapply(seq_len(n_workers), function(i) {
    list(
      start_pos = boundaries[[i]],
      end_pos = boundaries[[i + 1]]
    )
  })
}

process_file_multi <- function(file_name) {
  n_workers <- detectCores() - 1  
  cluster <- makeCluster(n_workers)
  registerDoParallel(cluster)
  
  process_chunk <- function(file_name, start_pos, end_pos) {
    neutral_values <- c(100, -100, 0, 0)
    result <- new.env()
    con <- file(file_name, "r")
    seek(con, start_pos)
    
    while (seek(con) < end_pos) {
      line <- readLines(con, n = 1, warn = FALSE)
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
    return(result)
  }
  
  chunks <- get_file_chunks(file_name)
  result <- foreach(i = chunks) %dopar% {
    process_chunk(
      file_name = file_name,
      start_pos = i$start_pos,
      end_pos = i$end_pos
    )
  }
  
  result_fmt <- list()
  for (chunk_res in result) {
    for (station_name in names(chunk_res)) {
      if (!(station_name %in% names(result_fmt))) {
        result_fmt[[station_name]] <- chunk_res[[station_name]]
      } else {
        result_fmt[[station_name]][1] <- min(result_fmt[[station_name]][1], chunk_res[[station_name]][1])
        result_fmt[[station_name]][3] <- result_fmt[[station_name]][3] + chunk_res[[station_name]][3]
        result_fmt[[station_name]][2] <- max(result_fmt[[station_name]][2], chunk_res[[station_name]][2])
        result_fmt[[station_name]][4] <- result_fmt[[station_name]][4] + chunk_res[[station_name]][4]
      }
    }
  }
  
  for (station_name in names(result_fmt)) {
    result_fmt[[station_name]][5] <- result_fmt[[station_name]][3] / result_fmt[[station_name]][4]
  }
  
  result_fmt <- result_fmt[order(names(result_fmt))]
  
  output <- "{"
  for (station_name in names(result_fmt)) {
    min_value <- result_fmt[[station_name]][1]
    mean_value <- result_fmt[[station_name]][5]
    max_value <- result_fmt[[station_name]][2]
    output <- paste0(output, station_name, "=", sprintf("%.1f/%.1f/%.1f, ", min_value, mean_value, max_value))
  }
  
  output <- substr(output, 1, nchar(output) - 2)
  output <- paste0(output, "}")
  output
  
  stopCluster(cluster)
}


# system.time(process_file_multithread("Code/1BRC/measurements.txt"))