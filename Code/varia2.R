
# this is just a sandbox with tons of ad-hoc codes without further explanations or comments

sum(log(1:10))
c(1,4) + 1:10

ans <- NULL
for(i in 1:507980) {
  if(x[i] < 0) ans <- c(ans, y[i])
}      
range(c(2, 100, -4, 3, 230, 5, c(4, -456, 9)))
x <- tibble(x = rnorm(1:10), y = runif(1:10), z = rbinom(1:10, 1, .5))
a <- 1:5
tibble(a, a * 2)
tibble(x = runif(10), y = x * 2)
mylist <- list(aaa=1:5, bbb=letters)
mylist[1:2][2]
mylist[[1]][[2]]
x <- -10:10
if(x < 1) y <- -1 else y <- 1
(x > 1)*2 - 1
sumxcol <- numeric(ncol(x))
for(i in 1:ncol(x)) sumxcol[i] <- sum(x[,i])
x %>%
  colSums()
rep(1, nrow(x)) %*% x
1:10-1

-2.3 ^ 4.5
x <- -2.3
x^4.5
?Syntax
3 == c(3, 1, 3, NA)
x1 <- 10:1
x1 == c(4, 6)
4 | 6
(4 | 6)

x <- 1:10
x
x == (4 | 6)
x == 4 | x == 6
x %in% c(4,6)
x3 <- 1:3
x3[c(0, 4)] <- c(-1, 9)

mat1 <- cbind(1:3, 7:9)
df1 <- data.frame(1:3, 7:9)
median(df1)
median(mat1)
?Quotes
nums <- seq(-1, 1, by=.01)
ans <- NULL
for(i in nums) ans[i] <- i^2

seq(-1, 1, by=.01)^2
myf <- factor(c(101:103,103))
attributes(myf)
myf
as.numeric(levels(myf))[myf]
ifelse(c(T,F,T), letters, LETTERS)
matrix(1:4, 2)
df3 <- data.frame(a = c(3:2), b = c('x', 'y'))
as.character(df3)
t3 <- tibble(a = c(3:2), b = c('x', 'y'))
as.character(t3[1,])

typeof(c(4, 0, 3))
is.numeric(c(4L, 0L, 3L))
names(mylist$b[[1]]) <- letters[1:10]
right <- wrong <- c(a=1, b=2)
length(data.frame(matrix(1:120, nrow = 15)))
