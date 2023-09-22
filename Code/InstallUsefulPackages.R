#some of the most ubiquitous packages
#together with dependencies, installs most of
#packages needed in my codes

install.packages("devtools")

pkg <- c("tidyverse",
         "tidymodels",
         "renv",
         "caret",
         "keras",
         "doParallel",
         "mlbench",
         "fastICA",
         "randomForest",
         "gbm",
         "gam",
         "Hmisc",
         "magick",
         "exiftoolr",
         "knitr",
         "RSQLite",
         "nnet",
         "tm",
         "markdown",
         "esquisse")

# load
for (i in seq(pkg)) {
  if (!library(pkg[i], character.only = TRUE, logical.return = TRUE)) {
    install.packages(pkg[i])
    library(pkg[i], character.only = TRUE)
  }
}

