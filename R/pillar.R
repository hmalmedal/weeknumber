#' @importFrom pillar type_sum
#' @export
type_sum.weeknumber <- function(x) {
  "week"
}

#' @importFrom pillar pillar_shaft
#' @export
pillar_shaft.weeknumber <- function(x, ...) {
  out <- format(x, justify = "right")
  out <- sub("-W", pillar::style_subtle("-W"), out, fixed = TRUE)
  out[is.na(x)] <- NA
  pillar::new_pillar_shaft_simple(out, align = "right")
}

#' @importFrom pillar is_vector_s3
#' @export
is_vector_s3.weeknumber <- function(x) {
  TRUE
}
