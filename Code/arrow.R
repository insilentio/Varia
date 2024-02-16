
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
open_dataset("//szh.loc/ssz/users/sszbad/Download/yellow_tripdata_2023-11.parquet")
write_dataset("data_nyc/nyc_arrow", partitioning = c("year", "month"), format = "arrow")
