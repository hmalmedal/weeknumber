test_that("arithmetic works", {
  x <- as_weeknumber(1000)
  y <- as_weeknumber(1001)
  expect_equal(y - x, 1)
  expect_equal(x + 1, y)
  expect_equal(1 + x, y)
  expect_equal(y - 1, x)
  expect_equal(+x, x)
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
