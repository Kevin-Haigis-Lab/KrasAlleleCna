#' Number of unique values
#'
#' Returns the number of unique values in a vector
#'
#' @param x vector
#'
#' @return integer
#'
#' @examples
#' a <- c(1,1,2,3,4)
#' n_unique(a)
#'
#' @export n_unique
n_unique <- function(x) length(unique(x))
