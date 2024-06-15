library(dplyr)
library(data.table)

process_file_dplyr <- function(file_name) {
  fread(file_name,
        header = TRUE,
        sep = ";",
        colClasses = c("character", "numeric")) |>
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


# system.time(process_file_dplyr("Code/1BRC/measurements.txt"))
