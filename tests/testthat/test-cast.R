test_that("cast works", {
  x <- new_weeknumber(1000)
  expect_equal(as_weeknumber(1000), x)
  expect_equal(as_weeknumber("2019-W10"), x)
  expect_equal(as_weeknumber(factor("2019-W10")), x)
  expect_equal(as_weeknumber(x), x)
  expect_equal(as_weeknumber(lubridate::make_date(2019, 3, 7)), x)
  y <- lubridate::make_datetime(2019, 3, 7, 12)
  expect_equal(as_weeknumber(y), x)
  expect_equal(as_weeknumber(as.POSIXlt(y)), x)
})

test_that("round-trip works", {
  x <- as_weeknumber(-1000:1000)
  expect_equal(as_weeknumber(x), x)
  expect_equal(as_weeknumber(as.double(x)), x)
  expect_equal(as_weeknumber(as.integer(x)), x)
  expect_equal(as_weeknumber(as.character(x)), x)
  expect_equal(as_weeknumber(as.factor(x)), x)
})

test_that("coercion gives correct class or type", {
  x <- as_weeknumber(0)
  expect_s3_class(as_weeknumber(x), "weeknumber")
  expect_type(as.double(x), "double")
  expect_type(as.integer(x), "integer")
  expect_type(as.character(x), "character")
  expect_s3_class(as.factor(x), "factor")
})
