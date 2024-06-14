library(readr)
load("Code/1BRC/stations.Rdata")

gen_values <- function(data, n = 1e9, format = "csv"){
  multiply <- n %/% nrow(data) + 1
  
  cities <- character(n)
  temp <- numeric(n)
  
  cities <- head(rep(data[[1]], multiply), n)
  temp <- rnorm(n, data[[2]], sd = 0.1)
  
  tibble(station_name = cities, measurement = temp) |> write_delim("Code/1BRC/measurements.txt", delim = ";")
}

gen_values(stations)
