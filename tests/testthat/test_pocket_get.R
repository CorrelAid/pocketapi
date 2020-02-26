context("pocket_get")

POCKET_TEST_CONSUMER_KEY <- Sys.getenv("POCKET_TEST_CONSUMER_KEY")
POCKET_TEST_ACCESS_TOKEN <- Sys.getenv("POCKET_TEST_ACCESS_TOKEN")

test_that("invalid access token causes error", {
  expect_error(pocket_get(access_token = "dsffköwejrl", consumer_key = POCKET_TEST_CONSUMER_KEY),
               regexp = "401 Unauthorized: A valid access token")
})

test_that("return value is data frame", {
  return_value <- pocket_get(consumer_key = POCKET_TEST_CONSUMER_KEY, access_token = POCKET_TEST_ACCESS_TOKEN)
  expect_s3_class(return_value, "data.frame")
  expect_gt(nrow(return_value), 0)
})
