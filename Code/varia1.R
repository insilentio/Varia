# various small code snippets

# Datumsrechnungen -----------------------------------------------------------------------------------
t <- as.Date("2009-06-25")
s <- as.Date("2007-12-25")
i <- as.Date("1973-09-15")
f <- as.Date("1981-05-22")

(Sys.Date() - t -> hl)
(Sys.Date() - s -> hj)
(Sys.Date() - i -> hd)
(Sys.Date() - f -> hb)
(44444 - (hl + hj + hd + hb))/4 + Sys.Date()
sum(hl,hj,hd,hb)


# Rechenmaschine ------------------------------------------------------------------------------

rechenmaschine <- function(x) {
  print(x <- x*6)
  print(x <- x/3)
  print(x <- x*2)
  print(x <- x*2)
  print(x <- x/8)
}

rechenmaschine(3)

# Fotosplit -----------------------------------------------------------------------------------

fotosplit <- function(r1 = 2/3, r2 = 1, h = 296, b = 293) {
  if (!is.null(r1) && !is.null(r2)) r2 <- NULL
  
  d <- (h-b)*2
  x <- (h - 3*d)/2
  if (is.null(r2)) {
    y <- x/r1
    z <- h - y -3*d
    r2 <- x/z
  }
  if (is.null(r1)) {
    z <- r2*x
    y <- h - z -3*d
    r1 <- y/x    
  }
  
  print(c(x, y, z, d, r1, r2))
}


# Lambda functions ----------------------------------------------------------------------------

integrate(function(x) sin(x), 0, pi)
integrate(sin(x), 0, pi)
lapply(mtcars, function(x) sd(x)/mean(x))
integrate(function(x) x^2 -x, 0, 10)

(function(x) x^3 /3 - x^2/2 )(10) 



# Normverteilungen etc. -----------------------------------------------------------------------

ggplot(tibble(x=rnorm(1000000))) +
  aes(x) +
  geom_histogram(bins=100) +
  scale_y_log10()
rng <- seq(-10,10,1e-2)
ggplot(tibble(x=rng,y=dnorm(rng))) +
  aes(x,y) +
  geom_point() +
  geom_vline(xintercept=-1) +
  geom_vline(xintercept = 1) +
  scale_y_log10()


x <- pretty(c(-3,3), 30)
y <- dnorm(x)
plot(x,y, type="o")
y <- dexp(x)
y <- dlogis(x)
y <- dmultinom(x)
y <- dpois(x)
y <- dhyper(x)



# EDA (exploratory data analysis) -------------------------------------------------------------

library(tidyverse)
library(DataExplorer)

gss_cat

gss_cat %>% glimpse()
gss_cat  %>% introduce()
gss_cat %>% plot_intro()
gss_cat %>% plot_missing()
gss_cat %>% profile_missing()
gss_cat  %>% plot_density()
gss_cat  %>% plot_histogram()
gss_cat  %>% plot_bar()
gss_cat  %>% plot_correlation()
gss_cat  %>% plot_correlation(maxcat = 5) 



# Abstände im n-dimensionalen Raum ------------------------------------------------------------

distance <-  function(dims = 1) {
  #create 1000 random points with n dims and calculate each distance (via lambda func)
  abst <- data.frame(dim=c(1:dims), dist=0)
  abst[,2] <- sapply(abst[,1], (function(n) mean(dist(matrix(runif(n*1e3), ncol = n)))))
  return(abst)
}

ggplot(distance(10)) +
  aes(dim,dist) +
  geom_line()


# Quadratic function --------------------------------------------------------------------------

quadf <- function(a = 1, b = 1, c = 0) {
  x1 <- (-b + sqrt(b^2 - 4*a*c))/(2*a)
  x2 <- (-b - sqrt(b^2 - 4*a*c))/(2*a)
  
  return(c(x1, x2))
}

quadf(1/3,-5/3,6/3)


