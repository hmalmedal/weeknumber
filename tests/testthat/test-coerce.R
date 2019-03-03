context("test-coerce")

test_that("coercion works", {
  x <- structure(1000, class = "weeknumber")
  expect_equal(as.weeknumber(1000), x)
  expect_equal(as.weeknumber("2019-W10"), x)
  expect_equal(as.weeknumber(factor("2019-W10")), x)
  expect_equal(as.weeknumber(x), x)
  expect_equal(as.weeknumber(lubridate::make_date(2019, 3, 7)), x)
  y <- lubridate::make_datetime(2019, 3, 7, 12)
  expect_equal(as.weeknumber(y), x)
  expect_equal(as.weeknumber(as.POSIXlt(y)), x)
})
