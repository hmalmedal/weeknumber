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
