#' @export
seq.weeknumber <- function(...) {
  weeknumber(NextMethod())
}

#' @export
as.Date.weeknumber <- function(x, ...) {
  vec_cast(x, new_date())
}

#' @export
as.POSIXlt.weeknumber <- function(x, ...) {
  vec_cast(x, as.POSIXlt(new_datetime()))
}
