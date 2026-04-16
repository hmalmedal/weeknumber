# Position scales for `weeknumber` vectors

`scale_x_weeknumber()` and `scale_y_weeknumber()` create continuous
ggplot2 position scales for `weeknumber` data on the x and y axes.

## Usage

``` r
scale_x_weeknumber(
  name = ggplot2::waiver(),
  breaks = ggplot2::waiver(),
  minor_breaks = ggplot2::waiver(),
  n.breaks = NULL,
  labels = ggplot2::waiver(),
  limits = NULL,
  expand = ggplot2::waiver(),
  oob = scales::censor,
  na.value = NA_real_,
  position = "bottom"
)

scale_y_weeknumber(
  name = ggplot2::waiver(),
  breaks = ggplot2::waiver(),
  minor_breaks = ggplot2::waiver(),
  n.breaks = NULL,
  labels = ggplot2::waiver(),
  limits = NULL,
  expand = ggplot2::waiver(),
  oob = scales::censor,
  na.value = NA_real_,
  position = "left"
)
```

## Arguments

- name, breaks, minor_breaks, n.breaks, labels, limits, expand, oob,
  na.value, position:

  Passed on to
  [`ggplot2::scale_x_continuous()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html)
  or
  [`ggplot2::scale_y_continuous()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html).
  See those functions for details.

## Value

A ggplot2 position scale for `weeknumber` data.

## Details

These helpers use the package's `weeknumber` transformation so ggplot2
can plot `weeknumber` vectors directly while preserving `weeknumber`
values for break calculations and labels. By default, breaks are chosen
from sensible weekly, monthly-ish, quarterly-ish, and yearly intervals
across the displayed range.

## Examples

``` r
df <- data.frame(
  week = make_weeknumber(2024, 1:6),
  value = c(3, 4, 2, 5, 6, 4)
)

ggplot2::ggplot(df, ggplot2::aes(week, value)) +
  ggplot2::geom_line() +
  scale_x_weeknumber()


ggplot2::ggplot(df, ggplot2::aes(value, week)) +
  ggplot2::geom_point() +
  scale_y_weeknumber()

```
