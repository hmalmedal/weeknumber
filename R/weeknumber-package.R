#' @import vctrs
#' @importFrom methods setOldClass
#' @aliases NULL weeknumber-package
#' @keywords package
"_PACKAGE"

origin <- 2000
origin_date <- lubridate::make_date(2000, 1, 3)
cycle_length <- 400
year_cycle <- seq(origin, length.out = cycle_length)
weeks_cycle <- lubridate::isoweek(lubridate::make_date(year_cycle, 12, 28))
year_intervals <- cumsum(c(0, weeks_cycle))

#' Low-level constructor for weeknumber vectors
#'
#' This is a low-level constructor that creates `weeknumber` vectors from their
#' underlying double representation.
#'
#' The underlying double values count ISO weeks relative to `2000-W01`, so `0`
#' represents `2000-W01`, `1` represents `2000-W02`, and so on. Non-finite
#' values are converted to `NA_real_`.
#'
#' This constructor follows the vctrs convention of validating only the
#' underlying storage type. Use [weeknumber()] for a user-facing helper and
#' [is_weeknumber()] to test for the class.
#'
#' @param x A double vector of ISO week offsets from `2000-W01`.
#'
#' @return A `weeknumber` vector.
#'
#' @examples
#' new_weeknumber(c(0, 1, NA_real_))
#' @export
new_weeknumber <- function(x = double()) {
  vec_assert(x, double())
  x[!is.finite(x)] <- NA
  new_vctr(x, class = "weeknumber")
}

#' Helper for weeknumber vectors
#'
#' This is a user-facing helper that casts `x` to double and then constructs a
#' `weeknumber` vector with [new_weeknumber()].
#'
#' This helper follows the vctrs convention of coercing user input before
#' calling the low-level constructor. For ISO year/week pairs, strings, or
#' date-time objects, use [make_weeknumber()] or [as_weeknumber()].
#'
#' @param x An object coercible to double.
#'
#' @return A `weeknumber` vector.
#'
#' @examples
#' weeknumber(0:2)
#' @export
weeknumber <- function(x = double()) {
  x <- vec_cast(x, double())
  new_weeknumber(x)
}

methods::setOldClass(c("weeknumber", "vctrs_vctr"))

#' Test for weeknumber vectors
#'
#' Tests whether an object inherits from the `weeknumber` class.
#'
#' @param x An object to test.
#'
#' @return `TRUE` if `x` is a `weeknumber` vector, otherwise `FALSE`.
#'
#' @examples
#' x <- weeknumber(10)
#' is_weeknumber(x)
#' is_weeknumber(10)
#' @export
is_weeknumber <- function(x) {
  inherits(x, "weeknumber")
}
