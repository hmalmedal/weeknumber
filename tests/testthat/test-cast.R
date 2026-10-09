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

test_that("character parsing consumes the entire string", {
  valid <- c("2020-W01", "2020W01", "2020-W1", "2020W1", "+2020-W01")
  expect_equal(as_weeknumber(valid), rep(make_weeknumber(2020, 1), length(valid)))
  invalid <- c(NA, "", "2020", "W01", "2020-W", "2020-W01-W02",
               "2020-W01junk", "2020--W01", "2020/w01", "2020-w01",
               "2020-W001", "2020.5-W01", "2020-W1.5", "2020-W1e1",
               "2020-W00", "2021-W53", " 2020-W01", "2020-W01 ")
  expect_warning(result <- as_weeknumber(invalid), NA)
  expect_equal(result, weeknumber(rep(NA_real_, length(invalid))))
  expect_equal(as_weeknumber(character()), weeknumber())
  expect_equal(as_weeknumber(factor(c("2020-W01", NA, "bad"))),
               c(make_weeknumber(2020, 1), weeknumber(c(NA, NA))))
})

test_that("known ISO transitions use the ISO year rather than calendar year", {
  dates <- as.Date(c("2000-01-01", "2000-01-03", "2020-12-31",
                     "2021-01-01", "2021-01-04", NA))
  expect_equal(format(as_weeknumber(dates)),
               c("1999-W52", "2000-W01", "2020-W53", "2020-W53", "2021-W01", NA))
  expect_equal(as_weeknumber(as.Date(numeric(), origin = "1970-01-01")), weeknumber())
  expect_equal(as_weeknumber(as.Date(c(NA, Inf, -Inf), origin = "1970-01-01")),
               weeknumber(rep(NA_real_, 3)))
})

test_that("date-time inputs respect the local ISO week", {
  local <- as.POSIXct(c("2021-01-04 00:30:00", NA), tz = "Pacific/Auckland")
  utc <- as.POSIXct(as.double(local), origin = "1970-01-01", tz = "UTC")
  expect_equal(format(as_weeknumber(local)), c("2021-W01", NA))
  expect_equal(format(as_weeknumber(utc)), c("2020-W53", NA))
  expect_equal(as_weeknumber(as.POSIXlt(local)), as_weeknumber(local))
})

test_that("date-time casts and common types preserve timezones", {
  x <- make_weeknumber(c(2021, NA), 1)
  for (tz in c("UTC", "Pacific/Auckland", "America/New_York")) {
    expected <- as.POSIXct(c("2021-01-04", NA), tz = tz)
    ct <- as.POSIXct(character(), tz = tz)
    lt <- as.POSIXlt(ct)
    for (to in list(ct, lt)) {
      cast <- vctrs::vec_cast(x, to)
      expect_equal(as.POSIXct(cast), expected)
      expect_equal(vctrs::vec_ptype2(x, to), ct)
      expect_equal(vctrs::vec_ptype2(to, x), ct)
      expect_equal(vctrs::vec_c(x, to), expected)
      expect_equal(vctrs::vec_c(to, x), expected)
      expect_equal(as_weeknumber(cast), x)
    }
    expect_equal(as.POSIXct(as.POSIXlt(x, tz = tz)), expected)
    expect_equal(as.POSIXct(x, tz = tz), expected)
  }
})

test_that("constructors and casts preserve storage and missing values", {
  x <- weeknumber(c(-1, 0, NA, NaN, Inf, -Inf))
  expect_equal(as.double(x), c(-1, 0, NA, NA, NA, NA))
  expect_equal(as_weeknumber(as.character(x)), x)
  expect_error(new_weeknumber(1L), class = "vctrs_error_assert_ptype")
  expect_error(vctrs::vec_cast(weeknumber(0.5), integer()), class = "vctrs_error_cast_lossy")
  expect_equal(format(weeknumber()), character())
  expect_equal(vctrs::vec_restore(c(-1, 0), x), weeknumber(c(-1, 0)))
  expect_equal(vctrs::vec_c(x[1], x[2]), x[1:2])
  expect_equal(vctrs::vec_c(x[1:2], as.Date("2000-01-10")),
               as.Date(c("1999-12-27", "2000-01-03", "2000-01-10")))
  expect_error(vctrs::vec_c(x, 1), class = "vctrs_error_incompatible_type")
})

test_that("factor casts respect target levels and report lossy conversions", {
  x <- c(make_weeknumber(2020, 1:2), weeknumber(NA_real_))
  levels <- c("2020-W02", "2020-W01", "unused")
  expect_equal(
    vctrs::vec_cast(x, factor(character(), levels = levels)),
    factor(c("2020-W01", "2020-W02", NA), levels = levels)
  )
  expect_error(
    vctrs::vec_cast(x, factor(character(), levels = "2020-W01")),
    class = "vctrs_error_cast_lossy"
  )
  expect_equal(vctrs::vec_cast(weeknumber(), factor(character(), levels = levels)),
               factor(character(), levels = levels))
})

test_that("round-trip works", {
  x <- as_weeknumber(-1000:1000)
  expect_equal(as_weeknumber(x), x)
  expect_equal(as_weeknumber(as.double(x)), x)
  expect_equal(as_weeknumber(as.integer(x)), x)
  expect_equal(as_weeknumber(as.character(x)), x)
  expect_equal(as_weeknumber(as.factor(x)), x)
  expect_equal(as_weeknumber(as.Date(x)), x)
  expect_equal(as_weeknumber(as.POSIXct(x)), x)
  expect_equal(as_weeknumber(as.POSIXlt(x)), x)
})

test_that("coercion gives correct class or type", {
  x <- as_weeknumber(0)
  expect_s3_class(as_weeknumber(x), "weeknumber")
  expect_type(as.double(x), "double")
  expect_type(as.integer(x), "integer")
  expect_type(as.character(x), "character")
  expect_s3_class(as.factor(x), "factor")
  expect_s3_class(as.Date(x), "Date")
  expect_s3_class(as.POSIXct(x), "POSIXct")
  expect_s3_class(as.POSIXlt(x), "POSIXlt")
})
