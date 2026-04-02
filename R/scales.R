weeknumber_trim_breaks_to_limits <- function(breaks, lower_limit, upper_limit) {
  breaks <- sort(unique(breaks))
  breaks[is.finite(breaks) & breaks >= lower_limit & breaks <= upper_limit]
}

weeknumber_regular_breaks <- function(lower_limit, upper_limit, interval,
                                      anchor = 0) {
  if (upper_limit < lower_limit) {
    return(double())
  }

  first_break <- lower_limit + ((anchor - lower_limit) %% interval)
  seq.int(first_break, upper_limit, by = interval)
}

weeknumber_year_week_breaks <- function(years, weeks, lower_limit, upper_limit) {
  breaks <- vec_data(
    make_weeknumber(
      rep(years, each = length(weeks)),
      rep(weeks, times = length(years))
    )
  )
  weeknumber_trim_breaks_to_limits(breaks, lower_limit, upper_limit)
}

weeknumber_select_spaced_years <- function(years, n) {
  n_years <- length(years)
  n <- min(n_years, max(1L, as.integer(n)))

  if (n == n_years) {
    return(years)
  }

  if (n <= 1L) {
    return(years[n_years])
  }

  spacing <- ceiling((n_years - 1) / (n - 1))
  selected_positions <- seq.int(1L, n_years, by = spacing)
  years[selected_positions]
}

weeknumber_choose_breaks <- function(candidates, max_breaks) {
  candidate_sizes <- vapply(candidates, length, integer(1))
  has_breaks <- candidate_sizes > 0L

  if (!any(has_breaks)) {
    return(double())
  }

  selected_index <- which(has_breaks & candidate_sizes <= max_breaks)[1]
  if (is.na(selected_index)) {
    selected_index <- which(has_breaks)[which.min(candidate_sizes[has_breaks])]
  }

  candidates[[selected_index]]
}

weeknumber_breaks <- function(n = 5) {
  function(x) {
    n <- suppressWarnings(as.integer(n))
    if (is.na(n)) {
      n <- 5L
    }

    max_breaks <- max(2L, n + 2L)
    week_numbers <- sort(vec_data(as_weeknumber(x)))
    week_numbers <- week_numbers[is.finite(week_numbers)]

    if (length(week_numbers) == 0) {
      return(new_weeknumber())
    }

    # ggplot2 passes expanded limits, so snap back to visible whole weeks.
    lower_limit <- ceiling(week_numbers[1])
    upper_limit <- floor(week_numbers[length(week_numbers)])

    if (upper_limit < lower_limit) {
      return(new_weeknumber())
    }

    if (lower_limit == upper_limit) {
      return(new_weeknumber(lower_limit))
    }

    years <- year_week(as_weeknumber(c(lower_limit, upper_limit)))$year
    years <- seq.int(years[1], years[2])

    candidates <- list(
      weeknumber_regular_breaks(lower_limit, upper_limit, interval = 1L),
      weeknumber_regular_breaks(lower_limit, upper_limit, interval = 2L),
      weeknumber_regular_breaks(lower_limit, upper_limit, interval = 4L),
      weeknumber_regular_breaks(lower_limit, upper_limit, interval = 8L),
      weeknumber_year_week_breaks(
        years, c(1L, 14L, 27L, 40L), lower_limit, upper_limit
      ),
      weeknumber_year_week_breaks(years, c(1L, 27L), lower_limit, upper_limit),
      weeknumber_year_week_breaks(years, 1L, lower_limit, upper_limit),
      weeknumber_year_week_breaks(
        weeknumber_select_spaced_years(years, max_breaks),
        1L,
        lower_limit,
        upper_limit
      )
    )

    new_weeknumber(as.double(weeknumber_choose_breaks(candidates, max_breaks)))
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
