# time series outliers

install.packages("fpp2")
library(fpp2)
library(forecast)
library(tidyverse)

#plot the time series
ggplot(gold) +
  aes(x = x, y = y) +
  geom_line()

# find the outliers
tsoutliers(gold)

# the tsclean replaces outliers and missings with interpolated values
ggplot() +
  geom_line(data = tsclean(gold), mapping = aes(x = x, y = y), colour = "red") +
  geom_line(data = gold, mapping = aes(x = x, y = y), colour = "grey") +
  geom_point(data = data.frame(tsoutliers(gold)), mapping = aes(x = index, y = replacements), colour = "blue", size = 2)
  