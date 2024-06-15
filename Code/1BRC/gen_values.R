library(readr)
library(dplyr)

load("Code/1BRC/stations.Rdata")

gen_values <- function(data, n = 1e9, format = "csv"){
  multiply <- n %/% nrow(data) + 1
  
  cities <- head(rep(data[[1]], multiply), n)
  temp <- round(rnorm(n, data[[2]], sd = 0.1), 1)
  
  values <- tibble(station_name = cities, measurement = temp)
  values |> write_delim("Code/1BRC/measurements.txt", delim = ";")
  values |> write_parquet("Code/1BRC/measurements.parquet")
}

gen_values(stations)
