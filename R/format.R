#' @export
format.weeknumber <- function(x, ...) {
  yw <- year_week(x)

  y <- formatC(yw$year, format = "f", digits = 0)
  ww <- formatC(yw$week, width = 2, format = "d", flag = "0")

  out <- paste0(y, "-W", ww)
  out[!is.finite(vec_data(x))] <- NA
  out
}
