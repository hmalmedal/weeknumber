#' @name internal
#' @method vec_arith weeknumber
#' @export
#' @export vec_arith.weeknumber
vec_arith.weeknumber <- function(op, x, y, ...) {
  UseMethod("vec_arith.weeknumber", y)
}

#' @method vec_arith.weeknumber default
#' @export
vec_arith.weeknumber.default <- function(op, x, y, ...) {
  stop_incompatible_op(op, x, y)
}

#' @method vec_arith.weeknumber weeknumber
#' @export
vec_arith.weeknumber.weeknumber <- function(op, x, y, ...) {
  switch(
    op,
    "-" = vec_arith_base(op, x, y),
    stop_incompatible_op(op, x, y)
  )
}

#' @method vec_arith.weeknumber numeric
#' @export
vec_arith.weeknumber.numeric <- function(op, x, y, ...) {
  switch(
    op,
    "+" = ,
    "-" = new_weeknumber(vec_arith_base(op, x, y)),
    stop_incompatible_op(op, x, y)
  )
}

#' @method vec_arith.numeric weeknumber
#' @export
vec_arith.numeric.weeknumber <- function(op, x, y, ...) {
  switch(
    op,
    "+" = new_weeknumber(vec_arith_base(op, x, y)),
    stop_incompatible_op(op, x, y)
  )
}

#' @method vec_arith.weeknumber MISSING
#' @export
vec_arith.weeknumber.MISSING <- function(op, x, y, ...) {
  switch(
    op,
    "+" = x,
    stop_incompatible_op(op, x, y)
  )
}
