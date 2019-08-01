context("pocket_add")

POCKET_TEST_CONSUMER_KEY <- Sys.getenv("POCKET_TEST_CONSUMER_KEY")
POCKET_TEST_ACCESS_TOKEN <- Sys.getenv("POCKET_TEST_ACCESS_TOKEN")

test_that("Consumer Key missing error occurs", {
  expect_error(
    pocket_add(access_token=POCKET_TEST_ACCESS_TOKEN, add_url="xAsdfcm13413"),
    regexp = "Argument 'consumer_key' is missing."
  )
})

test_that("Access token missing error occurs", {
  expect_error(
    pocket_add(consumer_key=POCKET_TEST_CONSUMER_KEY, add_url="xAsdfcm13413"),
    regexp = "Argument 'access_token' is missing."
  )
})

test_that("URL missing error occurs", {
  expect_error(
    pocket_add(consumer_key=POCKET_TEST_CONSUMER_KEY, access_token=POCKET_TEST_ACCESS_TOKEN),
    regexp = "Argument 'add_url' is missing."
  )
})

test_that("Consumer Key invalid error occurs", {
  expect_error(
    pocket_add(consumer_key="dasidadw", access_token=POCKET_TEST_ACCESS_TOKEN, add_url="xAsdfcm13413"),
    regexp = "A valid consumer key for Pocket"
  )
})

test_that("Consumer Key invalid error occurs", {
  result <- pocket_add(consumer_key=POCKET_TEST_CONSUMER_KEY, access_token=POCKET_TEST_ACCESS_TOKEN, add_url="https://katherinemwood.github.io/post/testthat/")
  expect_equal(
    result$status_code, 200)
})
