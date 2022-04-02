test_that("retry tries to runs the expressions the specified amount of times on failures", {
  expr_mock <- mockery::mock()

  expect_error(
    retry(
      expr = {
        expr_mock()
        stop("FAILURE")
      },
      retry_time = 0,
      retry_count = 5
    )
  )

  mockery::expect_called(expr_mock, n = 5)
})


test_that("retry returns the result of the passed expression", {
  result <- retry(
    expr = 2 + 4,
    retry_time = 0,
    retry_count = 2
  )

  expect_equal(result, 6)
})

test_that("retry sleeps the specified amount of seconds before each reattempt", {
  sleep_mock <- mockery::mock()
  expr_mock <- mockery::mock(stop("FAILURE!"), 5)

  mockery::stub(
    where = retry,
    what = "sleep",
    how = sleep_mock
  )

  retry(
    expr = expr_mock(),
    retry_time = 3,
    retry_count = 2
  )

  mockery::expect_called(sleep_mock, n = 1)
  mockery::expect_args(
    sleep_mock,
    n = 1,
    time = 3
  )
})


test_that("retry throws an error if expr failed in all reattempts", {
  expect_error(
    retry(
      expr = stop("FAILURE!"),
      retry_time = 0,
      retry_count = 5
    )
  )
})
