#' @import vctrs
#' @aliases NULL weeknumber-package
#' @keywords package
"_PACKAGE"

origin <- 2000
cycle_length <- 400
year_cycle <- seq(origin, length.out = cycle_length)
weeks_cycle <- lubridate::isoweek(lubridate::make_date(year_cycle, 12, 28))
year_intervals <- cumsum(c(0, weeks_cycle))

#' @name weeknumber
#' @export
new_weeknumber <- function(x = double()) {
  vec_assert(x, double())
  new_vctr(x, class = "weeknumber")
}

#' Week number class
#'
#' Constructor, helper and test functions for the week number class.
#'
#' @param x An object.
#' @export
weeknumber <- function(x = double()) {
  x <- vec_cast(x, double())
  new_weeknumber(x)
}

methods::setOldClass(c("weeknumber", "vctrs_vctr"))

#' @name weeknumber
#' @export
is_weeknumber <- function(x) inherits(x, "weeknumber")
