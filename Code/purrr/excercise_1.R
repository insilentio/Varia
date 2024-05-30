library(purrr)

mtcars |> 
  map(mean)

triple <- function(x) x * 3

map(1:3, triple)

triple(1:3)

map_dbl(1:3, triple)
