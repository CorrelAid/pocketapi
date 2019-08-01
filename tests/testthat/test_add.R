context("pocket_add")

test_that("Consumer Key invalid error occurs", {
  expect_error(
    pocket_add(consumer_key=POCKET_TEST_CONSUMER_KEY, access_token=POCKET_TEST_ACCESS_TOKEN, add_url="xAsdfcm13413")
  )
})
