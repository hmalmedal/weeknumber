#' Transformation for week numbers
#'
#' See \link[scales]{trans_new} for details.
#'
#' @export
weeknumber_trans <- function() {
  scales::trans_new(
    "weeknumber",
    transform = function(x) {
      structure(as.numeric(x), names = names(x))
    },
    inverse = weeknumber::as.weeknumber
  )
}

#' Scales for week numbers
#'
#' See \code{\link[ggplot2]{scale_continuous}} for details.
#'
#' @param name See link for details.
#' @param breaks See link for details.
#' @param minor_breaks See link for details.
#' @param labels See link for details.
#' @param limits See link for details.
#' @param expand See link for details.
#' @param oob See link for details.
#' @param na.value See link for details.
#' @param position See link for details.
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
