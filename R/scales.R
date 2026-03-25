weeknumber_break_crop <- function(x, x1, x2) {
  x <- sort(unique(x))
  x[is.finite(x) & x >= x1 & x <= x2]
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
  i <- unique(round(seq.int(1, length(years), length.out = min(length(years), n))))
  years[i]
}

weeknumber_break_select <- function(candidates, n) {
  sizes <- vapply(
    candidates,
    function(x) {
      if (length(x) == 0) {
        Inf
      } else {
        length(x)
      }
    },
    numeric(1)
  )

  i <- which(sizes <= n)[1]
  if (is.na(i)) {
    candidates[[length(candidates)]]
  } else {
    candidates[[i]]
  }
}

weeknumber_breaks <- function(n = 5) {
  function(x) {
    lim <- max(1L, as.integer(n) + 2L)
    x <- sort(vec_data(as_weeknumber(x)))
    x <- x[is.finite(x)]

    if (length(x) < 2) {
      return(new_weeknumber())
    }

    x1 <- floor(x[1])
    x2 <- ceiling(x[2])

    if (x2 < x1) {
      return(new_weeknumber())
    }

    if (x1 == x2) {
      return(new_weeknumber(x1))
    }

    years <- year_week(as_weeknumber(c(x1, x2)))$year
    years <- seq.int(years[1], years[2])

    candidates <- list(
      seq.int(x1, x2, by = 1L),
      seq.int(x1, x2, by = 2L),
      seq.int(x1, x2, by = 4L),
      seq.int(x1, x2, by = 8L),
      seq.int(x1, x2, by = 13L),
      seq.int(x1, x2, by = 26L),
      weeknumber_year_week_breaks(years, c(1L, 14L, 27L, 40L), x1, x2),
      weeknumber_year_week_breaks(years, c(1L, 27L), x1, x2),
      weeknumber_year_week_breaks(years, 1L, x1, x2),
      weeknumber_year_week_breaks(weeknumber_spaced_years(years, lim), 1L, x1, x2)
    )

    new_weeknumber(as.double(weeknumber_break_select(candidates, lim)))
  }
}

weeknumber_trans <- function() {
  scales::trans_new(
    "weeknumber",
    transform = vec_data,
    inverse = as_weeknumber,
    breaks = weeknumber_breaks()
  )
}

#' Scales for week numbers
#'
#' See [ggplot2::scale_continuous] for details.
#'
#' @param name,breaks,minor_breaks,labels,limits,expand,oob,na.value,position
#'   See link for details.
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
    trans = weeknumber_trans()
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
    trans = weeknumber_trans()
  )
}

#' @importFrom ggplot2 scale_type
#' @export
scale_type.weeknumber <- function(x) {
  "weeknumber"
}
