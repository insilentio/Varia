# new stuff in R

storms_sum <- storms %>% 
  filter(year %in% 1975:1977) %>% 
  group_by(year, status) %>% 
  summarise(mean = mean(pressure, na.rm = TRUE),
             median = median(pressure, na.rm = TRUE))

storms_sum %>% 
  pivot_wider(names_from = "year", values_from = c("mean", "median"))
wide_storms <- storms_sum %>% 
  tidyr::pivot_wider(names_from = "year", values_from = c("mean", "median"), 
                     names_glue = "{.value}_of_{year}")
wide_storms %>% 
  pivot_longer(-status, names_to = c("stat", "year"), 
                names_pattern = "(.*)_of_(.*)", 
                values_to = "value")


mtcars %>% 
  group_by(cyl) %>% 
  summarise(across(starts_with("d"), 
                  list(mean = mean, median = median), 
                  .names = "{fn}_of_{col}"))

mtcars %>% 
  nest_by(cyl) %>% 
  summarise(
    coefs = lm(mpg ~ disp + drat + carb, data = data)$coefficients,
    names = names(lm(mpg ~ disp + drat + carb, data = data)$coefficients)
  ) %>%
  pivot_wider(names_from = "names", values_from = "coefs", 
              names_glue = "{names}_coefficient" )

#############
rnorm(100, mean = 4, sd = 1) |> 
  density() |> 
  plot()

Map(
  \(x) {
    pattern = paste0("^", x)
    grep(pattern, ls("package:datasets"), value = TRUE, ignore.case = TRUE)
  },
  letters[1:3]
)
c("dogs", "cats", "rats") |>
  {\(x) grepl("at", x)}()

#instead of
split(mtcars, mtcars$gear)
#use
split(mtcars, ~ gear)
