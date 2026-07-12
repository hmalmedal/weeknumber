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

weeknumber_pick_break_set <- function(candidate_break_sets, target_breaks) {
  candidate_sizes <- vapply(candidate_break_sets, length, integer(1))
  has_breaks <- candidate_sizes > 0L

  if (!any(has_breaks)) {
    return(double())
  }

  # Treat `n.breaks` as a target. A small penalty for sparse candidates avoids
  # axes that become unexpectedly empty when two choices are equally close.
  scores <- abs(candidate_sizes - target_breaks) +
    0.25 * (candidate_sizes < target_breaks)
  scores[!has_breaks] <- Inf

  candidate_break_sets[[which.min(scores)]]
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

weeknumber_build_break_candidates <- function(lower_limit, upper_limit) {
  years_in_range <- weeknumber_years_in_limits(lower_limit, upper_limit)

  weekly_candidates <- lapply(c(1L, 2L, 4L, 8L, 13L, 26L), function(step) {
    weeknumber_generate_regular_breaks(lower_limit, upper_limit, step)
  })
  names(weekly_candidates) <- paste0("every_", c(1L, 2L, 4L, 8L, 13L, 26L),
                                    "_weeks")

  calendar_candidates <- list(
    quarter_starts = weeknumber_generate_year_week_breaks(
      years_in_range, c(1L, 14L, 27L, 40L), lower_limit, upper_limit
    ),
    half_year_starts = weeknumber_generate_year_week_breaks(
      years_in_range, c(1L, 27L), lower_limit, upper_limit
    ),
    year_starts = weeknumber_generate_year_week_breaks(
      years_in_range, 1L, lower_limit, upper_limit
    )
  )

  multi_year_candidates <- lapply(c(2L, 5L, 10L, 20L, 25L, 50L),
                                  function(step) {
    selected_years <- years_in_range[years_in_range %% step == 0L]
    weeknumber_generate_year_week_breaks(
      selected_years, 1L, lower_limit, upper_limit
    )
  })
  names(multi_year_candidates) <- paste0(
    "every_", c(2L, 5L, 10L, 20L, 25L, 50L), "_years"
  )

  # Calendar candidates come first so equally good choices prefer meaningful
  # ISO boundaries over grids tied only to the internal numeric representation.
  c(calendar_candidates, weekly_candidates, multi_year_candidates)
}

weeknumber_breaks <- function(n = 5) {
  default_n <- n
  force(default_n)

  function(x, n = default_n) {
    requested_breaks <- suppressWarnings(as.integer(n)[1])
    if (length(requested_breaks) == 0L || is.na(requested_breaks) ||
        requested_breaks < 1L) {
      requested_breaks <- 5L
    }
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
      upper_limit
    )
    selected_breaks <- weeknumber_pick_break_set(
      candidate_break_sets,
      requested_breaks
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
