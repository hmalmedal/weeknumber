weeknumber_break_crop <- function(x, x1, x2) {
  x <- sort(unique(x))
  x[is.finite(x) & x >= x1 & x <= x2]
}

weeknumber_step_breaks <- function(x1, x2, by, anchor = 0) {
  if (x2 < x1) {
    return(double())
  }

  start <- x1 + ((anchor - x1) %% by)
  seq.int(start, x2, by = by)
}

weeknumber_year_week_breaks <- function(years, weeks, x1, x2) {
  x <- vec_data(
    make_weeknumber(
      rep(years, each = length(weeks)),
      rep(weeks, times = length(years))
    )
  )
  weeknumber_break_crop(x, x1, x2)
}

weeknumber_spaced_years <- function(years, n) {
  n_years <- length(years)
  n <- min(n_years, max(1L, as.integer(n)))

  if (n == n_years) {
    return(years)
  }

  if (n <= 1L) {
    return(years[n_years])
  }

  step <- ceiling((n_years - 1) / (n - 1))
  i <- seq.int(1L, n_years, by = step)
  years[i]
}

weeknumber_break_select <- function(candidates, n) {
  sizes <- vapply(candidates, length, integer(1))
  keep <- sizes > 0L

  if (!any(keep)) {
    return(double())
  }

  i <- which(keep & sizes <= n)[1]
  if (is.na(i)) {
    i <- which(keep)[which.min(sizes[keep])]
  }

  candidates[[i]]
}

weeknumber_breaks <- function(n = 5) {
  function(x) {
    n <- suppressWarnings(as.integer(n))
    if (is.na(n)) {
      n <- 5L
    }

    lim <- max(2L, n + 2L)
    x <- sort(vec_data(as_weeknumber(x)))
    x <- x[is.finite(x)]

    if (length(x) == 0) {
      return(new_weeknumber())
    }

    # ggplot2 passes expanded limits, so snap back to visible whole weeks.
    x1 <- ceiling(x[1])
    x2 <- floor(x[length(x)])

    if (x2 < x1) {
      return(new_weeknumber())
    }

    if (x1 == x2) {
      return(new_weeknumber(x1))
    }

    years <- year_week(as_weeknumber(c(x1, x2)))$year
    years <- seq.int(years[1], years[2])

    candidates <- list(
      weeknumber_step_breaks(x1, x2, by = 1L),
      weeknumber_step_breaks(x1, x2, by = 2L),
      weeknumber_step_breaks(x1, x2, by = 4L),
      weeknumber_step_breaks(x1, x2, by = 8L),
      weeknumber_year_week_breaks(years, c(1L, 14L, 27L, 40L), x1, x2),
      weeknumber_year_week_breaks(years, c(1L, 27L), x1, x2),
      weeknumber_year_week_breaks(years, 1L, x1, x2),
      weeknumber_year_week_breaks(weeknumber_spaced_years(years, lim), 1L, x1, x2)
    )

    new_weeknumber(as.double(weeknumber_break_select(candidates, lim)))
  }
}

weeknumber_transform <- function() {
  scales::new_transform(
    "weeknumber",
    transform = vec_data,
    inverse = as_weeknumber,
    breaks = weeknumber_breaks()
  )
}

#' Position scales for `weeknumber` vectors
#'
#' `scale_x_weeknumber()` and `scale_y_weeknumber()` create continuous ggplot2
#' position scales for `weeknumber` data on the x and y axes.
#'
#' These helpers use the package's `weeknumber` transformation so ggplot2 can
#' plot `weeknumber` vectors directly while preserving `weeknumber` values for
#' break calculations and labels. By default, breaks are chosen from sensible
#' weekly, monthly-ish, quarterly-ish, and yearly intervals across the displayed
#' range.
#'
#' @param name,breaks,minor_breaks,labels,limits,expand,oob,na.value,position
#'   Passed on to [ggplot2::scale_x_continuous()] or
#'   [ggplot2::scale_y_continuous()]. See those functions for details.
#'
#' @return A ggplot2 position scale for `weeknumber` data.
#'
#' @examples
#' df <- data.frame(
#'   week = make_weeknumber(2024, 1:6),
#'   value = c(3, 4, 2, 5, 6, 4)
#' )
#'
#' ggplot2::ggplot(df, ggplot2::aes(week, value)) +
#'   ggplot2::geom_line() +
#'   scale_x_weeknumber()
#'
#' ggplot2::ggplot(df, ggplot2::aes(value, week)) +
#'   ggplot2::geom_point() +
#'   scale_y_weeknumber()
#'
#' @name scale_weeknumber
#' @export
scale_x_weeknumber <- function(name = ggplot2::waiver(),
                               breaks = ggplot2::waiver(),
                               minor_breaks = ggplot2::waiver(),
                               labels = ggplot2::waiver(),
                               limits = NULL,
                               expand = ggplot2::waiver(),
                               oob = scales::censor,
                               na.value = NA_real_,
                               position = "bottom") {
  ggplot2::scale_x_continuous(
    name = name,
    breaks = breaks,
    labels = labels,
    minor_breaks = minor_breaks,
    limits = limits,
    expand = expand,
    oob = oob,
    na.value = na.value,
    position = position,
    transform = weeknumber_transform()
  )
}

#' @name scale_weeknumber
#' @export
scale_y_weeknumber <- function(name = ggplot2::waiver(),
                               breaks = ggplot2::waiver(),
                               minor_breaks = ggplot2::waiver(),
                               labels = ggplot2::waiver(),
                               limits = NULL,
                               expand = ggplot2::waiver(),
                               oob = scales::censor,
                               na.value = NA_real_,
                               position = "left") {
  ggplot2::scale_y_continuous(
    name = name,
    breaks = breaks,
    labels = labels,
    minor_breaks = minor_breaks,
    limits = limits,
    expand = expand,
    oob = oob,
    na.value = na.value,
    position = position,
    transform = weeknumber_transform()
  )
}

#' @importFrom ggplot2 scale_type
#' @export
scale_type.weeknumber <- function(x) {
  "weeknumber"
}
