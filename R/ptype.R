#' @export
vec_ptype_abbr.weeknumber <- function(x) {
  "week"
}

#' @name internal
#' @method vec_ptype2 weeknumber
#' @export
#' @export vec_ptype2.weeknumber
vec_ptype2.weeknumber <- function(x, y, ...)
  UseMethod("vec_ptype2.weeknumber", y)

#' @method vec_ptype2.weeknumber default
#' @export
vec_ptype2.weeknumber.default <- function(x, y, ..., x_arg = "x", y_arg = "y")
  vec_default_ptype2(x, y, x_arg = x_arg, y_arg = y_arg)

#' @method vec_ptype2.weeknumber weeknumber
#' @export
vec_ptype2.weeknumber.weeknumber <- function(x, y, ...) new_weeknumber()

#' @method vec_ptype2.weeknumber double
#' @export
vec_ptype2.weeknumber.double <- function(x, y, ...) double()

#' @method vec_ptype2.double weeknumber
#' @export
vec_ptype2.double.weeknumber <- function(x, y, ...) double()

#' @method vec_ptype2.weeknumber integer
#' @export
vec_ptype2.weeknumber.integer <- function(x, y, ...) double()

#' @method vec_ptype2.integer weeknumber
#' @export
vec_ptype2.integer.weeknumber <- function(x, y, ...) double()

#' @method vec_ptype2.weeknumber character
#' @export
vec_ptype2.weeknumber.character <- function(x, y, ...) character()

#' @method vec_ptype2.character weeknumber
#' @export
vec_ptype2.character.weeknumber <- function(x, y, ...) character()

#' @method vec_ptype2.weeknumber factor
#' @export
vec_ptype2.weeknumber.factor <- function(x, y, ...) character()

#' @method vec_ptype2.factor weeknumber
#' @export
vec_ptype2.factor.weeknumber <- function(x, y, ...) character()

#' @method vec_ptype2.weeknumber Date
#' @export
vec_ptype2.weeknumber.Date <- function(x, y, ...) new_weeknumber()

#' @method vec_ptype2.Date weeknumber
#' @export
vec_ptype2.Date.weeknumber <- function(x, y, ...) new_weeknumber()

#' @method vec_ptype2.weeknumber POSIXt
#' @export
vec_ptype2.weeknumber.POSIXt <- function(x, y, ...) new_weeknumber()

#' @method vec_ptype2.POSIXt weeknumber
#' @export
vec_ptype2.POSIXt.weeknumber <- function(x, y, ...) new_weeknumber()
