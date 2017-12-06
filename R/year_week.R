#' Get year and week number
#'
#' @param x An object
#'
#' @return A named list with two elements: \code{year} and \code{week}.
#'
#' @examples
#' x <- as.weeknumber(c(-1:1, 51:52, NA))
#' year_week(x)
#'
#' @export
year_week <- function(x) {
  UseMethod("year_week")
}

#' @export
year_week.weeknumber <- function(x) {
  x <- unclass(x)

  cycle <- x %/% max(year_intervals)
  x <- x %% max(year_intervals)
  i <- findInterval(x, year_intervals)

  year <- origin + i + cycle * cycle_length - 1
  week <- x - year_intervals[i] + 1

  list(year = year, week = week)
}
