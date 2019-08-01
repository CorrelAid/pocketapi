library(pocketapi)

test_that("Consumer Key invalid error occurs", {
  expect_error(pocket_get(,access_token=NULL, add_item=c(), raw=FALSE), "Argument 'consumer_key' is missing. A valid consumer key for Pocket must be provided. See 'https://getpocket.com/developer/docs/authentication' on how to obtain one."))
})
