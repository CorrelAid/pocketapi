context("pocket_unfavorite")


test_that("missing consumer key causes error", {
    expect_error(
        pocket_unfavorite(item_ids = c("foobarid"), consumer_key = "", access_token = "faketoken"),
        regexp = "^POCKET_CONSUMER_KEY does not exist as environment variable."
    )
})

test_that("missing access token causes error", {
    expect_error(
        pocket_unfavorite(item_ids = c("foobarid"), consumer_key = "fakekey", access_token = ""),
        regexp = "^POCKET_ACCESS_TOKEN does not exist as environment variable."
    )
})

# send-28a90b-POST.json
with_mock_api({
    test_that("pocket_unfavorite - success generates message", {
        time_stub <- "2020-05-14 07:43:26 CEST"
        with_mock(
            Sys.time = function() time_stub,
            expect_message(
                pocket_unfavorite(item_ids = c("foobarid"), consumer_key = "fakekey", access_token = "faketoken"),
                regexp = "Action was successful"
            )
        )
    })
})


