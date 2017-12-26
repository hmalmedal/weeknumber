#' @export
as.character.weeknumber <- function(x, ...) {
  yw <- year_week(x)

  y <- formatC(yw$year, format = "f", digits = 0)
  ww <- formatC(yw$week, width = 2, format = "d", flag = "0")

  out <- paste0(y, "-W", ww)
  out[!is.finite(x)] <- NA
  length(out) <- length(x)
  out
}

#' @export
print.weeknumber <- function(x, ...) {
  xx <- as.character(x)
  names(xx) <- names(x)
  if (length(xx) > 0) {
    print(xx, ...)
  } else {
    cat("empty weeknumber")
  }
  invisible(x)
}

#' @export
format.weeknumber <- function(x, ...) {
  xx <- as.character(x)
  names(xx) <- names(x)
  format(xx, ...)
}

#' @export
c.weeknumber <- function(...) {
  structure(NextMethod(), class = "weeknumber")
}

#' @export
seq.weeknumber <- function(...) {
  structure(NextMethod(), class = "weeknumber")
}

#' @export
unique.weeknumber <- function(x, incomparables = FALSE, ...) {
  structure(NextMethod(), class = "weeknumber")
}

#' @export
as.list.weeknumber <- function(x, ...) {
  lapply(unclass(x), as.weeknumber)
}

#' @export
Math.weeknumber <- function(x, ...) {
  stop("undefined operation")
}

#' @export
floor.weeknumber <- function(x, ...) {
  structure(NextMethod(), class = "weeknumber")
}

#' @export
ceiling.weeknumber <- function(x, ...) {
  structure(NextMethod(), class = "weeknumber")
}

#' @export
trunc.weeknumber <- function(x, ...) {
  round(x - 0.4999999)
}

#' @export
round.weeknumber <- function(x, ...) {
  structure(NextMethod(), class = "weeknumber")
}

#' @export
cummax.weeknumber <- function(x, ...) {
  structure(NextMethod(), class = "weeknumber")
}

#' @export
cummin.weeknumber <- function(x, ...) {
  structure(NextMethod(), class = "weeknumber")
}

#' @export
Ops.weeknumber <- function(e1, e2) {
  stop("undefined operation")
}

#' @export
`+.weeknumber` <- function(e1, e2) {
  if (nargs() == 1) {
    structure(NextMethod(), class = "weeknumber")
  } else if (inherits(e1, "weeknumber") && inherits(e2, "weeknumber")) {
    stop("undefined operation")
  } else {
    structure(NextMethod(), class = "weeknumber")
  }
}

#' @export
`-.weeknumber` <- function(e1, e2) {
  if (nargs() == 1) {
    stop("undefined operation")
  } else if (inherits(e2, "weeknumber")) {
    stop("undefined operation")
  } else {
    structure(NextMethod(), class = "weeknumber")
  }
}

#' @export
`==.weeknumber` <- function(e1, e2) {
  NextMethod()
}

#' @export
`!=.weeknumber` <- function(e1, e2) {
  NextMethod()
}

#' @export
`<.weeknumber` <- function(e1, e2) {
  NextMethod()
}

#' @export
`<=.weeknumber` <- function(e1, e2) {
  NextMethod()
}

#' @export
`>=.weeknumber` <- function(e1, e2) {
  NextMethod()
}

#' @export
`>.weeknumber` <- function(e1, e2) {
  NextMethod()
}

#' @export
Complex.weeknumber <- function(z) {
  stop("undefined operation")
}

#' @export
Summary.weeknumber <- function(..., na.rm = FALSE) {
  stop("undefined operation")
}

#' @export
min.weeknumber <- function(..., na.rm = FALSE) {
  structure(NextMethod(), class = "weeknumber")
}

#' @export
max.weeknumber <- function(..., na.rm = FALSE) {
  structure(NextMethod(), class = "weeknumber")
}

#' @export
range.weeknumber <- function(..., na.rm = FALSE) {
  structure(NextMethod(), class = "weeknumber")
}

#' @export
`[.weeknumber` <- function(x, ...) {
  structure(NextMethod(), class = "weeknumber")
}

#' @export
`[[.weeknumber` <- function(x, ...) {
  structure(NextMethod(), class = "weeknumber")
}

#' @export
`[<-.weeknumber` <- function(x, ..., value) {
  structure(NextMethod(), class = "weeknumber")
}

#' @export
`[[<-.weeknumber` <- function(x, ..., value) {
  structure(NextMethod(), class = "weeknumber")
}

#' @export
as.data.frame.weeknumber <- as.data.frame.numeric
