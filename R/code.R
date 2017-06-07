#'export
func_a <- function() {
  1:10
}


#'export
func_b <- function(x) {
  my_data <- list("func_a" = letters[1:10])
  lazyeval::lazy_eval(lazyeval::lazy(x), data = my_data)
}
