#' Coerce to week number class
#'
#' Coerce an object to a `weeknumber` vector.
#'
#' Use `as_weeknumber()` to convert numbers, ISO week strings like
#' `"2000-W01"`, factors, and date-time objects to `weeknumber` values.
#'
#' @param x An object.
#'
#' @return A `weeknumber` vector.
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

#' @method vec_cast.weeknumber double
#' @export
vec_cast.weeknumber.double <- function(x, to, ...) {
  weeknumber(x)
}

#' @method vec_cast.weeknumber integer
#' @export
vec_cast.weeknumber.integer <- function(x, to, ...) {
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

#' @method vec_cast.Date weeknumber
#' @export
vec_cast.Date.weeknumber <- function(x, to, ...) {
  lubridate::as_date(vec_data(x) * 7 + vec_data(origin_date))
}

#' @method vec_cast.weeknumber POSIXct
#' @export
vec_cast.weeknumber.POSIXct <- vec_cast.weeknumber.Date

#' @method vec_cast.weeknumber POSIXlt
#' @export
vec_cast.weeknumber.POSIXlt <- vec_cast.weeknumber.Date

#' @method vec_cast.POSIXct weeknumber
#' @export
vec_cast.POSIXct.weeknumber <- function(x, to, ...) {
  vec_cast(vec_cast(x, new_date()), new_datetime())
}

#' @method vec_cast.POSIXlt weeknumber
#' @export
vec_cast.POSIXlt.weeknumber <- function(x, to, ...) {
  as.POSIXlt(vec_cast(x, new_datetime()))
}
