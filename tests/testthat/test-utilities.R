context("test-utilities")

test_that("number of unique vals works", {
  expect_equal(n_unique(c(1, 2, 3, 4)), 4)
  expect_equal(n_unique(c(1, 2, 3, 4, 4)), 4)
  expect_equal(n_unique(c(1, 2, 3, 4, NA)), 5)
  expect_equal(n_unique(c("A", "B", "C", "A")), 3)
})
