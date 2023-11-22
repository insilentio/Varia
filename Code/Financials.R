#' function to calculate expected amount at the end of a period
#'
#' @description simple calculation of the expected amount at pension based on
#' a start amount, payments, interest and runtime.
#' may be used to calculate expected value for third pillar, but also for reinvested
#' share capital
#' @param start the amount at the start (=now)
#' @param interest expected interest rate (in decimals)
#' @param yearlyamt yearly payments to raise the capital
#' @param endyear last year of payments
#' @param beginyear first year of payments. Current year as default
#'
#' @return a vector with the yearly amounts for the whole runtime
#' @export
#'
#' @examples

thirdpillar <- function(start, interest=.01, yearlyamt=7100, endyear, beginyear=NULL) {
  if (is.null(beginyear))
    beginyear <- as.numeric(format(Sys.Date(), "%Y"))
  runtime <- c(1:(endyear - beginyear))
  
  intofint <- (1 + interest)^runtime
  (start + runtime*yearlyamt)*intofint
}

