#' Coerce to week number class
#'
#' Coerce object to week number class.
#'
#' @param x An object.
#'
#' @examples
#' as.weeknumber(c(-1:1, 51:52, NA))
#' as.weeknumber("2000-W01")
#' as.weeknumber(as.Date("2000-12-28"))
#'
#' @export
as.weeknumber <- function(x) {
  UseMethod("as.weeknumber")
}

#' @export
as.weeknumber.numeric <- function(x) {
  structure(x, class = "weeknumber")
}

#' @export
as.weeknumber.character <- function(x) {
  l <- strsplit(x, "-W", fixed = TRUE)
  y <- vapply(l, `[`, "", i = 1)
  w <- vapply(l, `[`, "", i = 2)
  make_weeknumber(y, w)
}

#' @export
as.weeknumber.factor <- function(x) {
  as.weeknumber(as.character(x))
}

#' @export
as.weeknumber.weeknumber <- function(x) {
  unname(x)
}

#' @export
as.weeknumber.Date <- function(x) {
  make_weeknumber(lubridate::isoyear(x), lubridate::isoweek(x))
}

#' @export
as.weeknumber.POSIXct <- as.weeknumber.Date

#' @export
as.weeknumber.POSIXlt <- as.weeknumber.Date
