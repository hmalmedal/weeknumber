#' Make week number
#'
#' Make week number object from year and week.
#'
#' Input arguments are recycled. Invalid weeks result in `NA`.
#'
#' @param year Year, coerced to numeric.
#' @param week Week, coerced to numeric.
#'
#' @examples
#' make_weeknumber(2000:2001, 4:6)
#' make_weeknumber(2019:2020, 53)
#' @export
make_weeknumber <- function(year = 2000, week = 1) {
  l <- lengths(list(year, week))
  if (min(l) == 0) {
    return(new_weeknumber())
  }

  year <- as.numeric(year)
  week <- as.numeric(week)

  n <- max(l)
  year <- rep_len(year, n)
  week <- rep_len(week, n)

  cycle <- (year - origin) %/% cycle_length
  j <- (year %% cycle_length) + 1

  k <- (week > weeks_cycle[j]) | (week < 1)
  week[k] <- NA

  x <- year_intervals[j] + week + cycle * max(year_intervals) - 1

  new_weeknumber(x)
}
