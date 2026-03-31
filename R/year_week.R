#' Extract ISO year and week components
#'
#' `year_week()` returns the ISO 8601 year and week for a `weeknumber` vector.
#' For convenience, character, factor, `Date`, `POSIXct`, and `POSIXlt` inputs are
#' first converted with [as_weeknumber()].
#'
#' @param x A `weeknumber` vector, or an object coercible with
#'   [as_weeknumber()].
#'
#' @return A named list with components `year` and `week`, each the same length
#'   as `x`. Missing inputs produce missing values in both components.
#'
#' @examples
#' x <- make_weeknumber(c(2019, 2020, NA), c(52, 53, NA))
#' year_week(x)
#'
#' year_week(as.Date(c("2020-12-28", "2021-01-04")))
#' @export
year_week <- function(x) {
  UseMethod("year_week")
}

#' @export
year_week.weeknumber <- function(x) {
  x <- vec_data(x)

  cycle <- x %/% max(year_intervals)
  x <- x %% max(year_intervals)
  i <- findInterval(x, year_intervals)

  year <- origin + i + cycle * cycle_length - 1
  week <- x - year_intervals[i] + 1

  list(year = year, week = week)
}

#' @export
year_week.character <- function(x) {
  year_week(as_weeknumber(x))
}

#' @export
year_week.factor <- year_week.character

#' @export
year_week.Date <- year_week.character

#' @export
year_week.POSIXct <- year_week.character

#' @export
year_week.POSIXlt <- year_week.character
