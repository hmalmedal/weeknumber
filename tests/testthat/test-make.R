test_that("invalid week gives NA", {
  expect_true(is.na(make_weeknumber(2000, 0)))
  expect_true(is.na(make_weeknumber(2000, 53)))
})
