test_that("arithmetic works", {
  x <- as_weeknumber(1000)
  y <- as_weeknumber(1001)
  expect_equal(y - x, 1)
  expect_equal(x + 1, y)
  expect_equal(1 + x, y)
  expect_equal(y - 1, x)
  expect_equal(+x, x)
})

test_that("arithmetic recycles and handles empty and missing inputs", {
  x <- make_weeknumber(2020, 53)
  expect_equal(format(x + c(-1, 0, 1, NA)),
               c("2020-W52", "2020-W53", "2021-W01", NA))
  expect_equal(x + c(Inf, -Inf, NaN), weeknumber(rep(NA_real_, 3)))
  expect_equal(x + numeric(), weeknumber())
  expect_equal(weeknumber() - x, double())
  expect_equal(x + 0.5 - x, 0.5)
  expect_error(weeknumber(1:3) + 1:2, class = "vctrs_error_incompatible_size")
  for (op in c("*", "/", "^", "%%", "%/%")) {
    expect_error(do.call(op, list(x, 2)), class = "vctrs_error_incompatible_op")
  }
})

test_that("sequences handle endpoints, increments and requested lengths", {
  x <- make_weeknumber(2020, 53)
  expect_equal(seq(x, x + 2), x + 0:2)
  expect_equal(seq(x + 2, x), x + 2:0)
  expect_equal(seq(x + 4, x, by = -2), x + c(4, 2, 0))
  expect_equal(seq(x, length.out = 3), x + 0:2)
  expect_equal(seq(to = x, length.out = 3), x + (-2:0))
  expect_equal(seq(to = x, length.out = 3, by = 2), x + c(-4, -2, 0))
  expect_equal(seq(x, along.with = letters[1:3]), x + 0:2)
  expect_equal(seq(x, length.out = 0), weeknumber())
  expect_equal(seq(x, along.with = numeric(), by = 1), weeknumber())
  expect_equal(seq(x, x + 1, length.out = 3), x + c(0, 0.5, 1))
  expect_equal(seq(x, length.out = 2.1, by = 0), rep(x, 3))
  expect_error(seq(x, x + 1, by = -1))
  expect_error(seq(x, x + 1, by = 1, length.out = 2))
  for (by in list(NA_real_, Inf, -Inf, numeric(), c(1, 2), "week")) {
    expect_error(seq(x, length.out = 3, by = by))
  }
  for (n in list(NA_real_, Inf, -1, c(1, 2))) {
    expect_error(seq(x, length.out = n))
  }
  expect_error(seq(weeknumber(NA_real_), x))
})

test_that("sequence endpoints must be scalar week numbers", {
  x <- make_weeknumber(2020, 1)
  for (endpoint in list(as.Date("2020-01-20"), 3, "2020-W03", x + 0:1, weeknumber())) {
    expect_error(seq(x, endpoint))
    expect_error(seq(x, endpoint, by = 1))
    expect_error(seq.weeknumber(from = endpoint, to = x))
    expect_error(seq.weeknumber(from = endpoint, to = x, by = 1))
  }
})

test_that("seq works with weeknumber endpoints", {
  expect_equal(
    seq(as_weeknumber("2000-W01"), as_weeknumber("2000-W09"), by = 2),
    make_weeknumber(2000, c(1, 3, 5, 7, 9))
  )
})

test_that("seq requires length when one weeknumber endpoint is missing", {
  expect_error(
    seq(from = as_weeknumber("2000-W01")),
    "without 'by', when one of 'to', 'from' is missing"
  )
})

test_that("arithmetic fails", {
  x <- as_weeknumber(1000)
  expect_error(x + x, class = "vctrs_error_incompatible_op")
  expect_error(1 - x, class = "vctrs_error_incompatible_op")
  expect_error(x * 2, class = "vctrs_error_incompatible_op")
  expect_error(2 * x, class = "vctrs_error_incompatible_op")
  expect_error(-x, class = "vctrs_error_incompatible_op")
})
