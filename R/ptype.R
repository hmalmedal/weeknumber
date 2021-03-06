#' @export
vec_ptype_abbr.weeknumber <- function(x) {
  "week"
}

#' @name internal
#' @method vec_ptype2 weeknumber
#' @export
#' @export vec_ptype2.weeknumber
vec_ptype2.weeknumber <- function(x, y, ...) {
  UseMethod("vec_ptype2.weeknumber", y)
}

#' @method vec_ptype2.weeknumber default
#' @export
vec_ptype2.weeknumber.default <- function(x, y, ..., x_arg = "x", y_arg = "y") {
  vec_default_ptype2(x, y, x_arg = x_arg, y_arg = y_arg)
}

#' @method vec_ptype2.weeknumber weeknumber
#' @export
vec_ptype2.weeknumber.weeknumber <- function(x, y, ...) {
  new_weeknumber()
}

#' @method vec_ptype2.weeknumber Date
#' @export
vec_ptype2.weeknumber.Date <- function(x, y, ...) {
  new_date()
}

#' @method vec_ptype2.Date weeknumber
#' @export
vec_ptype2.Date.weeknumber <- function(x, y, ...) {
  new_date()
}

#' @method vec_ptype2.weeknumber POSIXct
#' @export
vec_ptype2.weeknumber.POSIXct <- function(x, y, ...) {
  new_datetime()
}

#' @method vec_ptype2.weeknumber POSIXlt
#' @export
vec_ptype2.weeknumber.POSIXlt <- function(x, y, ...) {
  new_datetime()
}

#' @method vec_ptype2.POSIXct weeknumber
#' @export
vec_ptype2.POSIXct.weeknumber <- function(x, y, ...) {
  new_datetime()
}

#' @method vec_ptype2.POSIXlt weeknumber
#' @export
vec_ptype2.POSIXlt.weeknumber <- function(x, y, ...) {
  new_datetime()
}
