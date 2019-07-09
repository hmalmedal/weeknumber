#' Get year and week number
#'
#' Get year and week number from an object.
#'
#' @param x An object.
#'
#' @return A named list with two elements: `year` and `week`.
#'
#' @examples
#' x <- as_weeknumber(c(-1:1, 51:52, NA))
#' year_week(x)
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
year_week.character <- function(x) year_week(as_weeknumber(x))

#' @export
year_week.factor <- year_week.character

#' @export
year_week.Date <- year_week.character

#' @export
year_week.POSIXt <- year_week.character
