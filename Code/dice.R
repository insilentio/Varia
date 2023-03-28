# some dice probabilities

# throw a dice n times and return values
dice <- function(n = 1L, eyes = 6L) {
  numbers <- seq(n)
  for (i in seq_len(n)) {
    numbers[i] <- sample(seq_len(eyes), 1)
  }
  
  numbers
}

# returns 1 if n is appearing exactly which times
count_n <- function(vec, n = 1, which = 1) {
  sum(sum(vec == n) == which)
}


# throw dice 50000 times and count how many times there is exactly 1 six
mylist <- lapply(as.list(rep(6L, 50000)), dice)
sum(unlist(lapply(mylist, count_n, 6)))

# count how many times there are exactly 6 sixes
sum(unlist(lapply(mylist, count_n, 6, 6)))
