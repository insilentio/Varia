library(dplyr)
library(data.table)
library(arrow)

process_file_dplyr <- function(file_name, parquet = FALSE) {
  gc()
  
  if (!parquet) {
    df <- fread(paste0(file_name, ".txt"),
          header = TRUE,
          sep = ";",
          colClasses = c("character", "numeric"))
  } else {
    # this creates an arrow object. Hence the following dplyr verbs get translated into
    # arrow and run in Acero (arrow query engine).
    df <- open_dataset(file.path(paste0(file_name, ".parquet")))
  }
  
  df |>   
    group_by(station_name) |> 
    summarise(
      min_measurement = min(measurement),
      mean_measurement = mean(measurement),
      max_measurement = max(measurement)
    ) |> 
    arrange(station_name) |>
    mutate(out = paste0(station_name, "=/", min_measurement, "/", round(mean_measurement, 1), "/", max_measurement)) |> 
    pull(out) |>
    paste0(collapse = ", ")
  
}

# system.time(process_file_dplyr("Data/measurements", parquet=TRUE))
