test_that("breaks keep every week for short ranges", {
  breaks <- weeknumber_breaks()(as_weeknumber(c(1000, 1004)))

  expect_equal(as.double(breaks), 1000:1004)
})

test_that("breaks thin medium ranges with stable weekly steps", {
  breaks <- weeknumber_breaks()(as_weeknumber(c(1000, 1012)))

  expect_equal(as.double(breaks), seq(1000, 1012, by = 2))
})

test_that("breaks stay on whole year starts for long ranges", {
  breaks <- weeknumber_breaks()(make_weeknumber(c(2000, 2020), 1))
  yw <- year_week(breaks)

  expect_lte(length(breaks), 7)
  expect_true(all(yw$week == 1))
  expect_equal(yw$year, sort(yw$year))
  expect_true(all(yw$year %in% 2000:2020))
})
