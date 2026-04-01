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

  expect_equal(as.double(breaks), seq(1000, 1012, by = 2))
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
