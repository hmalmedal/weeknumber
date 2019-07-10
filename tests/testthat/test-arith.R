test_that("arithmetic works", {
  x <- as_weeknumber(1000)
  y <- as_weeknumber(1001)
  expect_equal(y - x, 1)
  expect_equal(x + 1, y)
  expect_equal(1 + x, y)
  expect_equal(y - 1, x)
  expect_equal(+x, x)
})

test_that("arithmetic fails", {
  x <- as_weeknumber(1000)
  expect_error(x + x, class = "vctrs_error_incompatible_op")
  expect_error(1 - x, class = "vctrs_error_incompatible_op")
  expect_error(x * 2, class = "vctrs_error_incompatible_op")
  expect_error(2 * x, class = "vctrs_error_incompatible_op")
  expect_error(-x, class = "vctrs_error_incompatible_op")
})
