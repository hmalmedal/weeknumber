test_that("breaks keep every week for short ranges", {
  breaks <- weeknumber_breaks()(as_weeknumber(c(1000, 1004)))

  expect_equal(as.double(breaks), 1000:1004)
})

test_that("breaks ignore expanded limits and keep visible whole weeks", {
  weeks <- make_weeknumber(2024, 1:6)
  limits <- as.double(weeks[c(1, 6)]) + c(-0.25, 0.25)
  breaks <- weeknumber_breaks()(limits)

  expect_equal(as.double(breaks), as.double(weeks))
})

test_that("breaks thin medium ranges with stable weekly steps", {
  breaks <- weeknumber_breaks()(as_weeknumber(c(1000, 1012)))

  expect_equal(as.double(breaks), seq(1000, 1012, by = 4))
})

test_that("breaks handle missing, empty, reversed and fractional limits", {
  for (limits in list(numeric(), c(NA, Inf, -Inf), c(0.1, 0.9))) {
    expect_equal(weeknumber_breaks()(limits), weeknumber())
  }
  expect_equal(weeknumber_breaks()(c(1, 1)), weeknumber(1))
  expect_equal(weeknumber_breaks()(c(4.2, -0.2, NA)), weeknumber(0:4))
  for (n in list(NaN, Inf, -Inf, -1, "invalid")) {
    expect_equal(weeknumber_breaks(n)(c(1000, 1050)),
                 weeknumber_breaks()(c(1000, 1050)))
  }
  x <- make_weeknumber(c(2020, 2021), c(52, 2))
  expect_equal(format(weeknumber_breaks()(x)),
               c("2020-W52", "2020-W53", "2021-W01", "2021-W02"))
})

test_that("large ranges use sparse calendar-aligned breaks", {
  for (years in list(c(0, 10000), c(-1e9, 1e9))) {
    limits <- make_weeknumber(years, 1)
    for (n in c(1, 3, 5, 10)) {
      breaks <- weeknumber_breaks(n)(limits)
      yw <- year_week(breaks)
      expect_gt(length(breaks), 0)
      expect_lte(length(breaks), 2 * n)
      expect_true(all(yw$week == 1))
      expect_true(all(diff(as.double(breaks)) > 0))
      expect_true(all(breaks >= limits[1] & breaks <= limits[2]))
    }
  }
  expect_equal(year_week(weeknumber_breaks()(make_weeknumber(c(0, 10000), 1)))$year,
               seq(0, 10000, by = 2000))
})

test_that("both scales honor explicit breaks, labels and limits", {
  weeks <- make_weeknumber(c(2020, 2020, 2021, 2021), c(52, 53, 1, 2))
  df <- data.frame(week = weeks, value = 1:4)
  for (axis in c("x", "y")) {
    scale <- if (axis == "x") scale_x_weeknumber else scale_y_weeknumber
    mapping <- if (axis == "x") ggplot2::aes(week, value) else ggplot2::aes(value, week)
    p <- ggplot2::ggplot(df, mapping) + ggplot2::geom_point()
    panel <- ggplot2::ggplot_build(p + scale(
      breaks = weeks[c(2, 3)], labels = c("last", "first"),
      limits = weeks[c(2, 4)], expand = c(0, 0)
    ))$layout$panel_params[[1]][[axis]]
    expect_equal(panel$breaks, as.double(weeks[c(2, 3)]))
    expect_equal(panel$get_labels(), c("last", "first"))
    expect_equal(panel$continuous_range, as.double(weeks[c(2, 4)]))

    panel <- ggplot2::ggplot_build(p + scale(
      breaks = function(x) weeks[c(1, 4)],
      labels = function(x) paste("Week", year_week(x)$week),
      expand = c(0, 0)
    ))$layout$panel_params[[1]][[axis]]
    expect_equal(panel$breaks, as.double(weeks[c(1, 4)]))
    expect_equal(panel$get_labels(), c("Week 52", "Week 2"))
    panel <- ggplot2::ggplot_build(p + scale(breaks = NULL))$layout$panel_params[[1]][[axis]]
    expect_length(panel$breaks, 0)
  }
})

test_that("expanded scales place default breaks on visible whole weeks", {
  df <- data.frame(week = weeknumber(c(0, 1)), value = 1:2)
  panel <- ggplot2::ggplot_build(
    ggplot2::ggplot(df, ggplot2::aes(value, week)) +
      ggplot2::geom_point() +
      scale_y_weeknumber(expand = ggplot2::expansion(add = 2))
  )$layout$panel_params[[1]]$y
  expect_equal(panel$breaks, -2:3)
  expect_equal(panel$get_labels(), format(weeknumber(-2:3)))
})

test_that("breaks accept ggplot2's optional n argument", {
  breaks <- weeknumber_breaks()(c(make_weeknumber(2020, 1), make_weeknumber(2030, 1)), 3)
  yw <- year_week(breaks)

  expect_equal(yw$year, c(2020, 2025, 2030))
  expect_true(all(yw$week == 1))
})

test_that("breaks prefer quarter starts across longer cross-year ranges", {
  breaks <- weeknumber_breaks()(make_weeknumber(c(2024, 2025), c(5, 20)))
  yw <- year_week(breaks)

  expect_equal(yw$year, c(2024, 2024, 2024, 2025, 2025))
  expect_equal(yw$week, c(14, 27, 40, 1, 14))
})

test_that("breaks stay on whole year starts for long ranges", {
  breaks <- weeknumber_breaks()(make_weeknumber(c(2000, 2020), 1))
  yw <- year_week(breaks)

  expect_lte(length(breaks), 7)
  expect_true(all(yw$week == 1))
  expect_equal(yw$year, sort(yw$year))
  expect_true(all(yw$year %in% 2000:2020))
})

test_that("spaced long-range year breaks use nice gaps", {
  breaks <- weeknumber_breaks()(c(make_weeknumber(2020, 1), make_weeknumber(2030, 1)))
  yw <- year_week(breaks)

  expect_equal(yw$year, c(2020, 2022, 2024, 2026, 2028, 2030))
  expect_true(all(yw$week == 1))
})

test_that("spaced long-range year breaks do not force uneven endpoints", {
  breaks <- weeknumber_breaks()(c(make_weeknumber(2020, 1), make_weeknumber(2031, 1)))
  yw <- year_week(breaks)

  expect_equal(yw$year, c(2020, 2022, 2024, 2026, 2028, 2030))
  expect_true(all(yw$week == 1))
})

test_that("break count stays close to the requested target", {
  for (width in 4:300) {
    breaks <- weeknumber_breaks(5)(as_weeknumber(c(1000, 1000 + width)))
    expect_true(abs(length(breaks) - 5) <= 2, info = paste("width", width))
  }
})

test_that("invalid break counts fall back to the default", {
  limits <- as_weeknumber(c(1000, 1050))

  expect_equal(weeknumber_breaks(NULL)(limits), weeknumber_breaks()(limits))
  expect_equal(weeknumber_breaks(NA)(limits), weeknumber_breaks()(limits))
  expect_equal(weeknumber_breaks(0)(limits), weeknumber_breaks()(limits))
})

test_that("scale_x_weeknumber handles ggplot2 default expansion cleanly", {
  df <- data.frame(
    week = make_weeknumber(2024, 1:6),
    value = 1:6
  )

  panel <- ggplot2::ggplot_build(
    ggplot2::ggplot(df, ggplot2::aes(week, value)) +
      ggplot2::geom_point() +
      scale_x_weeknumber()
  )$layout$panel_params[[1]]$x

  expect_false(anyNA(panel$breaks))
  expect_equal(panel$breaks, as.double(df$week))
  expect_equal(panel$get_labels(), format(df$week))
})

test_that("scale_x_weeknumber forwards n.breaks to default breaks", {
  df <- data.frame(
    week = c(make_weeknumber(2020, 1), make_weeknumber(2030, 1)),
    value = c(1, 2)
  )

  default_panel <- ggplot2::ggplot_build(
    ggplot2::ggplot(df, ggplot2::aes(week, value)) +
      ggplot2::geom_point() +
      scale_x_weeknumber()
  )$layout$panel_params[[1]]$x

  panel <- ggplot2::ggplot_build(
    ggplot2::ggplot(df, ggplot2::aes(week, value)) +
      ggplot2::geom_point() +
      scale_x_weeknumber(n.breaks = 3)
  )$layout$panel_params[[1]]$x

  expect_lt(length(panel$breaks), length(default_panel$breaks))
  expect_equal(year_week(as_weeknumber(panel$breaks))$year, c(2020, 2025, 2030))
  expect_true(all(year_week(as_weeknumber(panel$breaks))$week == 1))
})

test_that("default ggplot scale handles short weeknumber ranges", {
  df <- data.frame(
    x = c(make_weeknumber(2000, 10), make_weeknumber(2000, 16)),
    y = 0
  )

  panel <- ggplot2::ggplot_build(
    ggplot2::ggplot(df, ggplot2::aes(x, y)) +
      ggplot2::geom_point()
  )$layout$panel_params[[1]]$x

  expect_false(anyNA(panel$breaks))
  expect_true(all(diff(panel$breaks) > 0))
})
