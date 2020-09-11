context("pocket_archive")


test_that("missing consumer key causes error", {
  expect_error(
    pocket_archive(item_ids = c("foobarid"), consumer_key = "", access_token = "faketoken"),
    regexp = "^POCKET_CONSUMER_KEY does not exist as environment variable.", class = "usethis_error"
  )
})

test_that("missing access token causes error", {
  expect_error(
    pocket_archive(item_ids = c("foobarid"), consumer_key = "fakekey", access_token = ""),
    regexp = "^POCKET_ACCESS_TOKEN does not exist as environment variable.", class = "usethis_error"
  )
})

# send-560791-POST.json
with_mock_api({
  test_that("pocket_archive - success generates message", {
    time_stub <- "2020-03-14 12:51:02 CET"
    with_mock(
      Sys.time = function() time_stub,
      expect_message(
        pocket_archive(item_ids = c("foobarid"), consumer_key = "fakekey", access_token = "faketoken"),
        regexp = "Action was successful"
      )
    )
  })
})



# send-e6ec69-POST.json
with_mock_api({
  test_that("pocket_archive - one success, one error", {
    time_stub <- "2020-03-14 12:51:02 CET"
    with_mock(
      Sys.time = function() time_stub,
      expect_warning(
        pocket_archive(item_ids = c("foo", "bar"), consumer_key = "fakekey", access_token = "faketoken"),
        regexp = "Action on bar failed with error: some error occurred"
      )
    )
  })
})
