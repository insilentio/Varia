MCPI <- function(size, forplot=FALSE, useloop=FALSE) {
## this function calculates Pi based on a Monte-Carlo-Simulation.
## figuratively, it assumes that a dart is thrown onto a square board. it counts how many times the dart
## ends up in the inlying unit circle; the proportion of hits vs. total tries is the same as the
## proportion of the areas of the circle vs. the square.
  
  # inits
  require(dplyr)

  if (useloop) {
  ##this part is basically obsolete, since it is using for-loop which is very slow.
  ##it helps understand the idea, so it is still there; plus it can be used to showcase the benefit of vectors
    
    #size_reduced is used to calculate a reduced size vector with averaged Pi values. This is very suitable
    #for plotting.
    size_reduced <- case_when(
      size <= 1e6 ~ 1000,
      size <= 1e8 ~ 10000,
      TRUE ~ 100000
    )
  
    inCircle <- 0
    #pre-filling large vectors is much faster than let the runtime extend it dynamically
    myPi <- rep(0,size)
    myPiMean <- rep(0,1000)
  
    ##throw the dart [size] many times
    for (i in 1:size) {
      # throw a dart randomly onto a square which surrounds a unit circle:
      x <- runif(1,-1,1)
      y <- runif(1,-1,1)
      #technically, we would have to compute the sqrt of the summed squares (Pythagoras)
      #but since we use a unit circle, we can save that time
      if((x^2 + y^2) <= 1) {
        # -> dart is in circle
        inCircle <- inCircle + 1
      }
  
      # proportion of how many darts have been in the circle:
      prop <- inCircle/i
      # this ist the same as the proportion of surface of circle vs. square:
      # circle: π*r^2
      # square: 4*r^2
      # which gives us π/4. So prop = π/4. Therefore:
      myPi[i] <- prop * 4
  
      #calculate the mean Pi value over the last [size] times
      #(for the plotting, we need to shrink the size to a reasonable size
      #otherwise, it will take forever to plot)
      if (i %% size_reduced == 0) {
        myPiMean[i/size_reduced] <- mean(myPi[(i-size_reduced+1):i])
      }
    }
    return(list(myPi = myPi, myPiMean = myPiMean))
  } 
  else {
  ##new part is vector based, approx. 100x faster. Two versions; one with intermediate results for plotting (as above),
  ##one with direct result (ultrafast)

    if (forplot) {
      #directly calculate all distances of randomly chosen points
      z <- runif(size,-1,1)^2 + runif(size,-1,1)^2

      #cumulatively count the circle hits
      z <- cumsum(z<=1)
      #use the proportion again to calculate Pi; the result is asymptotical towards Pi
      myPi <- z/seq.int(1,size,1)*4
      #this splits the Pi vector into 1000 chunks, calculates the mean to get a flattened curve in the end
      myPiMean <- split(myPi, cut(seq_along(myPi), 1000, labels = FALSE))
      myPiMean <- unlist(lapply(myPiMean, mean), use.names = FALSE)
      return(list(myPi = myPi, myPiMean = myPiMean))
    }
    else {
      #directly count the hits
      z <- sum((runif(size,-1,1)^2 + runif(size,-1,1)^2) <= 1)
      return(list(myPi = z/size*4))
    }
  }
}

size <- 1e7

#with plot
system.time(PiList <- MCPI(size, TRUE))
plot(PiList$myPiMean, type = "l", ylim = c(pi-(1/size)^.4,pi+(1/size)^.4))
abline(h = pi, col = "red")
print(paste0(round((1 - pi/tail(PiList$myPi, 1))*100, 4), "%"), quote = F)

#without plot
system.time(PiList <- MCPI(size, FALSE))

#result
tail(PiList$myPi, 1)
print(paste0(round((1 - pi/tail(PiList$myPi, 1))*100, 4), "%"), quote = F)

#how does it look when you run the function multiple times?
library(purrr)
system.time(PiList <- unlist(map(seq_len(100), ~MCPI(size, FALSE)), use.names = FALSE))
# for size = 1e8 (-> 1e10 estimates for Pi)
#        User      System verstrichen 
# 494.606      37.164     531.972 
# > mean(PiList)
# [1] 3.141588

#old school (using for-loop) (careful when using size > 1e6)
system.time(PiList <- MCPI(size, useloop = TRUE))



#run a test
benchmark <- function(x = 1, size = 1000) {
  t1 <- replicate(x, system.time(MCPI(size, TRUE)))
  t2 <- replicate(x, system.time(MCPI(size, FALSE)))
  t3 <- replicate(x, system.time(MCPI(size/10, useloop = TRUE)))
  cat("pro Mia.:",c(mean(t1[3]), mean(t2[3]), mean(t3[3])*10))
}
benchmark(10, 1e7)

