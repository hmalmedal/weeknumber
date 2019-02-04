weeknumber_breaks <- function(n = 5) {
  function(x) {
    lim <- n + 2

    x1 <- floor(x[1])
    x2 <- ceiling(x[2])

    y1 <- year_week(x1)$year
    y2 <- year_week(x2)$year
    y <- c(y1, y2)

    if (diff(y) > 10) {
      return(
        make_weeknumber(scales::pretty_breaks(n = n)(y))
      )
    }

    y <- seq(y1, y2)
    w <- seq(x1, x2)
    breaks <- w

    if (length(breaks) > lim) {
      i <- unclass(w) %% 2 == 0
      breaks <- w[i]
    }
    if (length(breaks) > lim) {
      i <- unclass(w) %% 4 == 0
      breaks <- w[i]
    }
    if (length(breaks) > lim) {
      i <- unclass(w) %% 8 == 0
      breaks <- w[i]
    }
    if (length(breaks) > lim) {
      d <- expand.grid(y = y, w = c(1, 14, 27, 40))
      breaks <- w[w %in% make_weeknumber(d$y, d$w)]
    }
    if (length(breaks) > lim) {
      d <- expand.grid(y = y, w = c(1, 27))
      breaks <- w[w %in% make_weeknumber(d$y, d$w)]
    }
    if (length(breaks) > lim) {
      y_breaks <- scales::pretty_breaks(n = n)(y)
      breaks <- w[w %in% make_weeknumber(y_breaks)]
    }
    breaks
  }
}

weeknumber_trans <- function() {
  scales::trans_new(
    "weeknumber",
    transform = function(x) {
      structure(as.numeric(x), names = names(x))
    },
    inverse = as.weeknumber,
    breaks = weeknumber_breaks()
  )
}

#' Scales for week numbers
#'
#' See [ggplot2::scale_x_continuous()] for details.
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
