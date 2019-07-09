#' Make week number
#'
#' Make week number object from year and week.
#'
#' Input arguments are recycled to their common size. Invalid weeks result in
#' `NA`.
#'
#' @param year Year, coerced to numeric.
#' @param week Week, coerced to numeric.
#'
#' @examples
#' make_weeknumber(2000:2001, 4:5)
#' make_weeknumber(2019:2020, 53)
#' @export
make_weeknumber <- function(year = 2000, week = 1) {
  n <- vec_recycle_common(year = year, week = week)

  year <- as.numeric(n$year)
  week <- as.numeric(n$week)

  cycle <- (year - origin) %/% cycle_length
  j <- (year %% cycle_length) + 1

  k <- (week > weeks_cycle[j]) | (week < 1)
  week[k] <- NA

  x <- year_intervals[j] + week + cycle * max(year_intervals) - 1

  new_weeknumber(x)
}
