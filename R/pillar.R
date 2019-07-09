#' @importFrom pillar pillar_shaft
#' @export
pillar_shaft.weeknumber <- function(x, ...) {
  out <- format(x, justify = "right")
  out <- sub("-W", pillar::style_subtle("-W"), out, fixed = TRUE)
  pillar::new_pillar_shaft_simple(out, align = "right")
}
