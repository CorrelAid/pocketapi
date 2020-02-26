context("pocket_add")

POCKET_TEST_CONSUMER_KEY <- Sys.getenv("POCKET_TEST_CONSUMER_KEY")
POCKET_TEST_ACCESS_TOKEN <- Sys.getenv("POCKET_TEST_ACCESS_TOKEN")

test_that("missing consumer key causes error", {
  expect_error(
    pocket_add(add_url = "xAsdfcm13413", consumer_key = "", access_token = POCKET_TEST_ACCESS_TOKEN),
    regexp = "POCKET_CONSUMER_KEY does not exist as environment variable."
  )
})

test_that("missing access token causes error", {
  expect_error(
    pocket_add(add_url = "xAsdfcm13413", consumer_key = POCKET_TEST_CONSUMER_KEY, access_token = ""),
    regexp = "POCKET_ACCESS_TOKEN does not exist as environment variable."
  )
})

test_that("missing URL causes error", {
  expect_error(
    pocket_add(),
    regexp = "Argument 'add_url' is missing."
  )
})

test_that("invalid consumer key causes error", {
  expect_error(
    pocket_add(
      consumer_key = "dasidadw",
      access_token = POCKET_TEST_ACCESS_TOKEN,
      add_url = "xAsdfcm13413"
    ),
    regexp = "403 Forbidden: The provided keys do not have proper permission"
  )
})

test_that("Valid case", {
  testthat::skip_on_travis()
  result <-
    pocket_add(consumer_key = POCKET_TEST_CONSUMER_KEY,
               access_token = POCKET_TEST_ACCESS_TOKEN,
               add_url = "https://katherinemwood.github.io/post/testthat/")
  expect_equal(result$status_code, 200)
})
