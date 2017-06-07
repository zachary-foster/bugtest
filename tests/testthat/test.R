library(bugtest)
context("error testing")

test_that("can reproduce bug", {
  print(func_b(func_a))
})
