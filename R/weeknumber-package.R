#' @keywords package
"_PACKAGE"

origin <- 2000
cycle_length <- 400
year_cycle <- seq(origin, length.out = cycle_length)
weeks_cycle <- lubridate::isoweek(lubridate::make_date(year_cycle, 12, 28))
year_intervals <- cumsum(c(0, weeks_cycle))
