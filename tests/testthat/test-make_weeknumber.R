test_that("invalid week gives NA", {
  expect_true(is.na(make_weeknumber(2000, 0)))
  expect_true(is.na(make_weeknumber(2000, 53)))
})

test_that("missing, non-finite and fractional components are invalid", {
  invalid <- c(NA_real_, NaN, Inf, -Inf, 2000.5, -0.5)
  expect_equal(make_weeknumber(invalid, 1), weeknumber(rep(NA_real_, 6)))
  invalid <- c(NA_real_, NaN, Inf, -Inf, 0, -1, 54, 1.5, 52.5)
  expect_equal(make_weeknumber(2020, invalid), weeknumber(rep(NA_real_, 9)))
  expect_equal(
    make_weeknumber(c(2000, NA, 2020, 2021), c(1, 1, 53, NA)),
    weeknumber(c(0, NA, 1095, NA))
  )
})

test_that("components recycle using vctrs rules", {
  expect_equal(make_weeknumber(2000, 1:3), weeknumber(0:2))
  expect_equal(make_weeknumber(2000:2002, 1), make_weeknumber(2000:2002, rep(1, 3)))
  expect_equal(make_weeknumber(numeric(), 1), weeknumber())
  expect_equal(make_weeknumber(2000, numeric()), weeknumber())
  expect_error(make_weeknumber(2000:2002, 1:2), class = "vctrs_error_incompatible_size")
  expect_error(make_weeknumber(numeric(), 1:2), class = "vctrs_error_incompatible_size")
  expect_equal(make_weeknumber("2000", "1"), weeknumber(0))
})

test_that("ISO calendar agrees with independent Thursday and January 4 rules", {
  # Two full Gregorian cycles, including century leap-year exceptions.
  dates <- seq(as.Date("1600-01-01"), as.Date("2399-12-31"), by = "day")
  weekday <- (as.double(dates) + 3) %% 7 # Monday = 0
  monday <- dates - weekday
  thursday <- monday + 3
  year <- as.numeric(format(thursday, "%Y"))
  jan4 <- as.Date(paste0(year, "-01-04"))
  first_monday <- jan4 - (as.double(jan4) + 3) %% 7
  week <- as.double(monday - first_monday) / 7 + 1

  x <- as_weeknumber(dates)
  expect_equal(year_week(x), list(year = year, week = week))
  expect_equal(make_weeknumber(year, week), x)
  expect_equal(as.Date(x), monday)
  expect_equal(as.double(x), as.double(monday - as.Date("2000-01-03")) / 7)
})

test_that("53-week years and cycles work before and after the origin", {
  expect_equal(is.na(make_weeknumber(c(1900, 2000, 2015, 2020, 2021, 2100), 53)),
               c(TRUE, TRUE, FALSE, FALSE, TRUE, TRUE))
  years <- c(-801, -400, -1, 0, 1, 1599, 1600, 1999, 2000, 2399, 2400)
  x <- make_weeknumber(years, 1)
  expect_equal(year_week(x), list(year = years, week = rep(1, length(years))))
  expect_equal(make_weeknumber(years + 400, 1) - x, rep(20871, length(years)))
  expect_equal(as_weeknumber(format(x)), x)
  expect_equal(year_week(weeknumber()), list(year = double(), week = double()))
  expect_equal(year_week(weeknumber(c(NA, Inf, -Inf))),
               list(year = rep(NA_real_, 3), week = rep(NA_real_, 3)))
})
