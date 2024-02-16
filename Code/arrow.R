
# Parquet file format
# is a column storage
# therefore tends to be massively smaller
library(arrow)

data(penguins, package = "palmerpenguins")
parquet <- tempfile(fileext = ".parquet")
csv <- tempfile(fileext = ".csv")
write_parquet(penguins, sink = parquet)
readr::write_csv(penguins, file = csv)

fs::file_info(c(parquet, csv))[, "size"]


#Arrow
#platform for in-memory data
#also in column storage mode
#careful, dataset is really big:
#data_nyc = "data/nyc-taxi"
data_nyc = "data/nyc-taxi"
open_dataset("s3://voltrondata-labs-datasets/nyc-taxi") |>
  dplyr::filter(year %in% 2012:2021) |> 
  write_dataset(data_nyc, partitioning = c("year", "month"))

nrow(open_dataset(data_nyc))

open_dataset(data_nyc)

open_dataset(file.path(data_path, "year=2019")) |>
  write_dataset("data/nyc-taxi-arrow", partitioning = "month", 
                format = "arrow")

