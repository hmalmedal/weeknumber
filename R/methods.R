#' Generate Sequences of Week Numbers
#'
#' Generate regular sequences of `weeknumber` values.
#'
#' This method mirrors classed `seq()` methods such as [seq.Date()]. Supply
#' `from` and `to`, or one endpoint together with `length.out`/`along.with`.
#' When `by` is supplied, it should be a single numeric week increment.
#'
#' @param from A length-1 `weeknumber` vector giving the start of the
#'   sequence.
#' @param to A length-1 `weeknumber` vector giving the end of the sequence.
#' @param by A length-1 numeric week increment.
#' @param length.out Desired length of the output sequence.
#' @param along.with Take the length from this object.
#' @param ... Unused.
#'
#' @return A `weeknumber` vector.
#'
#' @examples
#' seq(make_weeknumber(2000, 1), make_weeknumber(2000, 9), by = 2)
#' seq(from = make_weeknumber(2000, 1), length.out = 3, by = 1)
#'
#' @export
seq.weeknumber <- function(from, to, by, length.out = NULL,
                           along.with = NULL, ...) {
  if (!missing(along.with)) {
    length.out <- length(along.with)
  } else if (!is.null(length.out)) {
    if (length(length.out) != 1L) {
      stop("'length.out' must be of length 1", call. = FALSE)
    }
    length.out <- ceiling(length.out)
  }

  if (missing(by)) {
    m_to <- missing(to)
    m_from <- missing(from)

    if (m_to && m_from) {
      stop("without 'by', at least one of 'to' and 'from' must be specified", call. = FALSE)
    }

    if ((m_to || m_from) && is.null(length.out)) {
      stop(
        "without 'by', when one of 'to', 'from' is missing, 'length.out' / 'along.with' must be specified",
        call. = FALSE
      )
    }

    if (!m_from) {
      from <- vec_data(from)
    }
    if (!m_to) {
      to <- vec_data(to)
    }

    res <- if (m_from) {
      seq.int(to = to, length.out = length.out)
    } else if (m_to) {
      seq.int(from, length.out = length.out)
    } else {
      seq.int(from, to, length.out = length.out)
    }

    return(weeknumber(res))
  }

  if (length(by) != 1L) {
    stop("'by' must be of length 1", call. = FALSE)
  }
  if (is_weeknumber(by)) {
    by <- vec_data(by)
  }
  if (!is.numeric(by)) {
    stop("invalid mode for 'by'", call. = FALSE)
  }
  if (is.na(by)) {
    stop("'by' is NA", call. = FALSE)
  }

  missing_arg <- names(which(c(
    from = missing(from),
    to = missing(to),
    length.out = is.null(length.out)
  )))
  if (length(missing_arg) != 1L) {
    stop(
      "given 'by', exactly two of 'to', 'from' and 'length.out' / 'along.with' must be specified",
      call. = FALSE
    )
  }

  res <- switch(
    missing_arg,
    from = seq.int(to = vec_data(to), by = by, length.out = length.out),
    to = seq.int(from = vec_data(from), by = by, length.out = length.out),
    length.out = seq.int(from = vec_data(from), to = vec_data(to), by = by)
  )

  weeknumber(res)
}

#' @export
as.Date.weeknumber <- function(x, ...) {
  vec_cast(x, new_date())
}

#' @export
as.POSIXlt.weeknumber <- function(x, ...) {
  vec_cast(x, as.POSIXlt(new_datetime()))
}
