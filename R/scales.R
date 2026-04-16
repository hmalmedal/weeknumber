weeknumber_keep_breaks_in_limits <- function(break_values, lower_limit,
                                             upper_limit) {
  break_values <- sort(unique(break_values))
  is_visible_break <- is.finite(break_values) &
    break_values >= lower_limit &
    break_values <= upper_limit

  break_values[is_visible_break]
}

weeknumber_generate_regular_breaks <- function(lower_limit, upper_limit, step) {
  if (upper_limit < lower_limit) {
    return(double())
  }

  # Keep regular breaks aligned to a stable step grid instead of restarting at
  # each panel's lower limit.
  offset_to_first_break <- (-lower_limit) %% step
  first_break <- lower_limit + offset_to_first_break
  if (first_break > upper_limit) {
    return(double())
  }

  seq.int(first_break, upper_limit, by = step)
}

weeknumber_generate_year_week_breaks <- function(years, weeks, lower_limit,
                                                 upper_limit) {
  # `make_weeknumber()` drops invalid year/week combinations such as week 53 in
  # years that do not have one; trim the remaining values to the visible range.
  break_values <- vec_data(
    make_weeknumber(
      rep(years, each = length(weeks)),
      rep(weeks, times = length(years))
    )
  )

  weeknumber_keep_breaks_in_limits(break_values, lower_limit, upper_limit)
}

weeknumber_select_evenly_spaced_years <- function(years, n) {
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

weeknumber_pick_break_set <- function(candidate_break_sets, max_breaks) {
  candidate_sizes <- vapply(candidate_break_sets, length, integer(1))
  has_breaks <- candidate_sizes > 0L

  if (!any(has_breaks)) {
    return(double())
  }

  first_candidate_within_limit <- which(
    has_breaks & candidate_sizes <= max_breaks
  )[1]
  if (!is.na(first_candidate_within_limit)) {
    return(candidate_break_sets[[first_candidate_within_limit]])
  }

  smallest_non_empty_candidate <- which(has_breaks)[
    which.min(candidate_sizes[has_breaks])
  ]
  candidate_break_sets[[smallest_non_empty_candidate]]
}

weeknumber_visible_week_limits <- function(week_values) {
  # ggplot2 passes expanded numeric limits; snap them back to whole weeks.
  c(
    lower = ceiling(week_values[1]),
    upper = floor(week_values[length(week_values)])
  )
}

weeknumber_years_in_limits <- function(lower_limit, upper_limit) {
  # Convert the numeric limits back to ISO years so cross-year ranges include
  # every year that could contribute a boundary-aligned break.
  limit_years <- year_week(as_weeknumber(c(lower_limit, upper_limit)))$year
  seq.int(limit_years[1], limit_years[2])
}

weeknumber_build_break_candidates <- function(lower_limit, upper_limit,
                                              max_breaks) {
  years_in_range <- weeknumber_years_in_limits(lower_limit, upper_limit)

  # Order matters: choose the first non-empty candidate that stays within the
  # allowed count, moving from dense weekly breaks toward sparse yearly breaks.
  list(
    weekly = weeknumber_generate_regular_breaks(
      lower_limit, upper_limit, step = 1L
    ),
    every_other_week = weeknumber_generate_regular_breaks(
      lower_limit, upper_limit, step = 2L
    ),
    every_four_weeks = weeknumber_generate_regular_breaks(
      lower_limit, upper_limit, step = 4L
    ),
    every_eight_weeks = weeknumber_generate_regular_breaks(
      lower_limit, upper_limit, step = 8L
    ),
    quarter_starts = weeknumber_generate_year_week_breaks(
      years_in_range, c(1L, 14L, 27L, 40L), lower_limit, upper_limit
    ),
    half_year_starts = weeknumber_generate_year_week_breaks(
      years_in_range, c(1L, 27L), lower_limit, upper_limit
    ),
    year_starts = weeknumber_generate_year_week_breaks(
      years_in_range, 1L, lower_limit, upper_limit
    ),
    spaced_year_starts = weeknumber_generate_year_week_breaks(
      weeknumber_select_evenly_spaced_years(years_in_range, max_breaks),
      1L,
      lower_limit,
      upper_limit
    )
  )
}

weeknumber_breaks <- function(n = 5) {
  default_n <- n
  force(default_n)

  function(x, n = default_n) {
    requested_breaks <- suppressWarnings(as.integer(n))
    if (is.na(requested_breaks)) {
      requested_breaks <- 5L
    }

    # Allow a small cushion so we can keep stable calendar-aligned break sets.
    max_breaks <- max(2L, requested_breaks + 2L)
    week_values <- sort(vec_data(as_weeknumber(x)))
    week_values <- week_values[is.finite(week_values)]

    if (length(week_values) == 0) {
      return(new_weeknumber())
    }

    visible_limits <- weeknumber_visible_week_limits(week_values)
    lower_limit <- visible_limits[["lower"]]
    upper_limit <- visible_limits[["upper"]]

    if (upper_limit < lower_limit) {
      return(new_weeknumber())
    }

    if (lower_limit == upper_limit) {
      return(new_weeknumber(lower_limit))
    }

    candidate_break_sets <- weeknumber_build_break_candidates(
      lower_limit,
      upper_limit,
      max_breaks
    )
    selected_breaks <- weeknumber_pick_break_set(
      candidate_break_sets,
      max_breaks
    )

    new_weeknumber(as.double(selected_breaks))
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
#' @param name,breaks,minor_breaks,n.breaks,labels,limits,expand,oob,na.value,position
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
                               n.breaks = NULL,
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
    n.breaks = n.breaks,
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
                               n.breaks = NULL,
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
    n.breaks = n.breaks,
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
