#' Coerce to week number class
#'
#' Coerce object to week number class.
#'
#' @param x An object.
#'
#' @examples
#' as_weeknumber(c(-1:1, 51:52, NA))
#' as_weeknumber("2000-W01")
#' as_weeknumber(as.Date("2000-12-28"))
#' @export
as_weeknumber <- function(x) {
  vec_cast(x, new_weeknumber())
}

#' @name internal
#' @method vec_cast weeknumber
#' @export
#' @export vec_cast.weeknumber
vec_cast.weeknumber <- function(x, to, ...) {
  UseMethod("vec_cast.weeknumber")
}

#' @method vec_cast.weeknumber default
#' @export
vec_cast.weeknumber.default <- function(x, to, ...) {
  vec_default_cast(x, to)
}

#' @method vec_cast.weeknumber weeknumber
#' @export
vec_cast.weeknumber.weeknumber <- function(x, to, ...) {
  x
}

#' @method vec_cast.weeknumber numeric
#' @export
vec_cast.weeknumber.numeric <- function(x, to, ...) {
  weeknumber(x)
}

#' @method vec_cast.double weeknumber
#' @export
vec_cast.double.weeknumber <- function(x, to, ...) {
  vec_data(x)
}

#' @method vec_cast.integer weeknumber
#' @export
vec_cast.integer.weeknumber <- function(x, to, ...) {
  vec_cast(vec_data(x), integer())
}

#' @method vec_cast.weeknumber character
#' @export
vec_cast.weeknumber.character <- function(x, to, ...) {
  l <- strsplit(x, "-?W")
  y <- vapply(l, `[`, "", i = 1)
  w <- vapply(l, `[`, "", i = 2)
  make_weeknumber(y, w)
}

#' @method vec_cast.character weeknumber
#' @export
vec_cast.character.weeknumber <- function(x, to, ...) {
  format(x)
}

#' @method vec_cast.weeknumber factor
#' @export
vec_cast.weeknumber.factor <- function(x, to, ...) {
  vec_cast(vec_cast(x, character()), new_weeknumber())
}

#' @method vec_cast.factor weeknumber
#' @export
vec_cast.factor.weeknumber <- function(x, to, ...) {
  vec_cast(vec_cast(x, character()), new_factor())
}

#' @method vec_cast.weeknumber Date
#' @export
vec_cast.weeknumber.Date <- function(x, to, ...) {
  make_weeknumber(lubridate::isoyear(x), lubridate::isoweek(x))
}

#' @method vec_cast.weeknumber POSIXt
#' @export
vec_cast.weeknumber.POSIXt <- vec_cast.weeknumber.Date
