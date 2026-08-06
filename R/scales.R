weeknumber_week_steps <- c(1L, 2L, 4L, 8L, 13L, 26L)
weeknumber_year_steps <- c(2L, 5L, 10L, 20L, 25L, 50L)
weeknumber_calendar_weeks <- list(
  quarter_starts = c(1L, 14L, 27L, 40L),
  half_year_starts = c(1L, 27L),
  year_starts = 1L
)

weeknumber_keep_visible_breaks <- function(breaks, limits) {
  breaks <- sort(unique(breaks))
  is_visible <- is.finite(breaks) &
    breaks >= limits[["lower"]] &
    breaks <= limits[["upper"]]

  breaks[is_visible]
}

weeknumber_regular_breaks <- function(limits, step) {
  first_break <- ceiling(limits[["lower"]] / step) * step

  if (first_break > limits[["upper"]]) {
    return(double())
  }

  # Starting at a multiple of `step` keeps the grid stable across panels.
  seq.int(first_break, limits[["upper"]], by = step)
}

weeknumber_year_week_breaks <- function(years, weeks, limits) {
  year_week_grid <- expand.grid(year = years, week = weeks)
  breaks <- vec_data(
    make_weeknumber(year_week_grid$year, year_week_grid$week)
  )

  # Invalid combinations, such as week 53 in a 52-week year, become `NA`.
  weeknumber_keep_visible_breaks(breaks, limits)
}

weeknumber_pick_break_set <- function(candidates, target_count) {
  candidate_sizes <- lengths(candidates)
  has_breaks <- candidate_sizes > 0L

  if (!any(has_breaks)) {
    return(double())
  }

  # Treat `n.breaks` as a target. A small penalty for sparse candidates avoids
  # axes that become unexpectedly empty when two choices are equally close.
  scores <- abs(candidate_sizes - target_count) +
    0.25 * (candidate_sizes < target_count)
  scores[!has_breaks] <- Inf

  candidates[[which.min(scores)]]
}

weeknumber_visible_week_limits <- function(week_values) {
  # ggplot2 passes expanded numeric limits; snap them back to whole weeks.
  limits <- c(
    lower = ceiling(week_values[1]),
    upper = floor(week_values[length(week_values)])
  )

  limits
}

weeknumber_years_in_limits <- function(limits) {
  # Convert the numeric limits back to ISO years so cross-year ranges include
  # every year that could contribute a boundary-aligned break.
  limit_years <- year_week(as_weeknumber(limits))$year
  seq.int(limit_years[1], limit_years[2])
}

weeknumber_build_break_candidates <- function(limits) {
  years <- weeknumber_years_in_limits(limits)

  weekly_candidates <- lapply(weeknumber_week_steps, function(step) {
    weeknumber_regular_breaks(limits, step)
  })
  names(weekly_candidates) <- paste0(
    "every_", weeknumber_week_steps, "_weeks"
  )

  calendar_candidates <- lapply(weeknumber_calendar_weeks, function(weeks) {
    weeknumber_year_week_breaks(years, weeks, limits)
  })

  multi_year_candidates <- lapply(weeknumber_year_steps, function(step) {
    selected_years <- years[years %% step == 0L]
    weeknumber_year_week_breaks(selected_years, 1L, limits)
  })
  names(multi_year_candidates) <- paste0(
    "every_", weeknumber_year_steps, "_years"
  )

  # Calendar candidates come first so equally good choices prefer meaningful
  # ISO boundaries over grids tied only to the internal numeric representation.
  c(calendar_candidates, weekly_candidates, multi_year_candidates)
}

weeknumber_break_count <- function(n, default = 5L) {
  count <- suppressWarnings(as.integer(n)[1])

  if (length(count) == 0L || is.na(count) || count < 1L) {
    return(default)
  }

  count
}

weeknumber_breaks <- function(n = 5) {
  default_n <- n
  force(default_n)

  function(x, n = default_n) {
    target_count <- weeknumber_break_count(n)
    week_values <- sort(vec_data(as_weeknumber(x)))
    week_values <- week_values[is.finite(week_values)]

    if (length(week_values) == 0) {
      return(new_weeknumber())
    }

    visible_limits <- weeknumber_visible_week_limits(week_values)

    if (visible_limits[["upper"]] < visible_limits[["lower"]]) {
      return(new_weeknumber())
    }

    if (visible_limits[["lower"]] == visible_limits[["upper"]]) {
      return(new_weeknumber(visible_limits[["lower"]]))
    }

    candidates <- weeknumber_build_break_candidates(visible_limits)
    selected_breaks <- weeknumber_pick_break_set(candidates, target_count)

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
#' plot `weeknumber` vectors directly and format axis labels as ISO year-week
#' values.
#'
#' When `breaks` is left at its default, the scale chooses a regular weekly or
#' calendar-aligned interval that is close to `n.breaks`. Candidate intervals
#' include 1, 2, 4, 8, 13, and 26 weeks; quarter, half-year, and year starts; and
#' sensible multi-year intervals. Calendar-aligned breaks are preferred when
#' candidates are equally close to the requested number. Consequently,
#' `n.breaks` is a target rather than a guarantee.
#'
#' Supply `breaks` or `labels` to override the defaults in the same way as for
#' [ggplot2::scale_x_continuous()]. Expansion added by ggplot2 is excluded from
#' the default break calculation, so ticks remain on whole visible weeks.
#'
#' @param n.breaks Approximate number of major breaks. The default break
#'   algorithm treats this as a target and may return a nearby number to retain
#'   regular or calendar-aligned spacing.
#' @param name,breaks,minor_breaks,labels,limits,expand,oob,na.value,guide,position,sec.axis
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
#' # Request fewer major breaks while retaining calendar-aware spacing.
#' ggplot2::ggplot(df, ggplot2::aes(week, value)) +
#'   ggplot2::geom_line() +
#'   scale_x_weeknumber(n.breaks = 3)
#'
#' ggplot2::ggplot(df, ggplot2::aes(value, week)) +
#'   ggplot2::geom_point() +
#'   scale_y_weeknumber()
#'
#' @name scale_weeknumber
#' @export
scale_x_weeknumber <- function(
    name = ggplot2::waiver(),
    breaks = ggplot2::waiver(),
    minor_breaks = ggplot2::waiver(),
    n.breaks = NULL,
    labels = ggplot2::waiver(),
    limits = NULL,
    expand = ggplot2::waiver(),
    oob = scales::censor,
    na.value = NA_real_,
    guide = ggplot2::waiver(),
    position = "bottom",
    sec.axis = ggplot2::waiver()
) {
  ggplot2::scale_x_continuous(
    name = name,
    breaks = breaks,
    minor_breaks = minor_breaks,
    n.breaks = n.breaks,
    labels = labels,
    limits = limits,
    expand = expand,
    oob = oob,
    na.value = na.value,
    transform = weeknumber_transform(),
    guide = guide,
    position = position,
    sec.axis = sec.axis
  )
}

#' @name scale_weeknumber
#' @export
scale_y_weeknumber <- function(
    name = ggplot2::waiver(),
    breaks = ggplot2::waiver(),
    minor_breaks = ggplot2::waiver(),
    n.breaks = NULL,
    labels = ggplot2::waiver(),
    limits = NULL,
    expand = ggplot2::waiver(),
    oob = scales::censor,
    na.value = NA_real_,
    guide = ggplot2::waiver(),
    position = "left",
    sec.axis = ggplot2::waiver()
) {
  ggplot2::scale_y_continuous(
    name = name,
    breaks = breaks,
    minor_breaks = minor_breaks,
    n.breaks = n.breaks,
    labels = labels,
    limits = limits,
    expand = expand,
    oob = oob,
    na.value = na.value,
    transform = weeknumber_transform(),
    guide = guide,
    position = position,
    sec.axis = sec.axis
  )
}

#' @importFrom ggplot2 scale_type
#' @export
scale_type.weeknumber <- function(x) {
  "weeknumber"
}
