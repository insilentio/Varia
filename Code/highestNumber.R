# finde höchste Zahl n, die aus lauter verschiedenen Ziffern besteht, wobei 2*n ebenfalls aus lauter
# verschiedenen Zahlen besteht
decomp <- function (x) {
  n <- floor(log10(x))
  x %/% 10^seq(n, 0) %% 10
}

get_number <- function(digits) {
  limit <- floor(as.integer(paste(rep(9, digits), collapse = ""))/2)
  
  for (i in seq(limit, 1)) {
    
    a <- decomp(i)
    if (length(unique(a)) == length(a)) {
      b <- decomp(i*2)
      
      # check if all digits are unique
      if (length(unique(c(a, b))) == length(c(a, b))) {
        break
      }
    }
  }
  
  #first entry is biggest possible number
  print(c(i, i*2))
}

get_number(4)
