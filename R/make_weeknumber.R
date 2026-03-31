#' Make weeknumber from ISO year and week
#'
#' Construct a `weeknumber` vector from ISO 8601 year and week values.
#'
#' Input arguments are recycled to their common size, using
#' [vctrs::vec_recycle_common()]. Weeks outside the valid range for the
#' corresponding year result in `NA`.
#'
#' @param year Year, coerced to numeric.
#' @param week ISO week, coerced to numeric.
#'
#' @return A `weeknumber` vector.
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
