# some dice probabilities

# throw a dice n times and return values
dice <- function(n = 1L, eyes = 6L) {
  eyes <- seq_len(eyes)
  sample(eyes, n, replace = TRUE)
}

# returns how many times n is appearin
count_n <- function(vec, n = 1) {
  sum(vec == n)
}

# check if it is a tutto
check_tutto <- function(vec) {
  cnt1 <- count_n(vec, 1)
  cnt2 <- count_n(vec, 2)
  cnt3 <- count_n(vec, 3)
  cnt4 <- count_n(vec, 4)
  cnt5 <- count_n(vec, 5)
  cnt6 <- count_n(vec, 6)
  
  div_by_3 <- function(x) {
    if (x > 0 && x %% 3 == 0)
      x %/% 3
    else
      0
  }
  
  cnt2t <- div_by_3(cnt2)
  cnt3t <- div_by_3(cnt3)
  cnt4t <- div_by_3(cnt4)
  cnt6t <- div_by_3(cnt6)
  
  if ((cnt1 + cnt5) == 6) {
    return(TRUE)
  } else if ((cnt1 + cnt5) == 3) {
    if (sum(cnt2t, cnt3t, cnt4t, cnt6t) == 1)
      return(TRUE)
    else
      return(FALSE)
  } else if ((cnt1 + cnt5) == 0) {
    if (sum(cnt2t, cnt3t, cnt4t, cnt6t) == 2)
      return(TRUE)
    else
      return(FALSE)   
  } else
    return(FALSE)
}


# throw dice 50000 times and count how many times there is exactly 1 six
system.time(mylist <- lapply(as.list(rep(6L, 1e6)), dice))

psum(unlist(lapply(mylist, count_n, 6)))

# count how many times there are exactly 6 sixes
sum(unlist(lapply(mylist, count_n, 6, 6)))

sum(unlist(lapply(mylist, check_tutto)))
