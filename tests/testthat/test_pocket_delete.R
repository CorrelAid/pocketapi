context("pocket_delete")


test_that("missing consumer key causes error", {
    expect_error(
        pocket_delete(item_ids = c("foobarid"), consumer_key = "", access_token = "faketoken"),
        regexp = "^POCKET_CONSUMER_KEY does not exist as environment variable."
    )
})

test_that("missing access token causes error", {
    expect_error(
        pocket_delete(item_ids = c("foobarid"), consumer_key = "fakekey", access_token = ""),
        regexp = "^POCKET_ACCESS_TOKEN does not exist as environment variable."
    )
})


# send-1972e8-POST.json
with_mock_api({
    test_that("pocket_delete - success generates message", {
        time_stub <- "2020-03-14 12:51:02 CET"
        with_mock(
            Sys.time = function() time_stub,
            expect_message(
                pocket_delete(item_ids = c("foobarid"), consumer_key = "fakekey", access_token = "faketoken"),
                regexp = "Action was successful for the items: foobarid"
            )
        )
    })
})


# send-476df7-POST.json
with_mock_api({
    test_that("pocket_delete - two successes", {
        time_stub <- "2020-03-14 12:51:02 CET"
        with_mock(
            Sys.time = function() time_stub,
            expect_message(
                pocket_delete(item_ids = c("faz", "bar"), consumer_key = "fakekey", access_token = "faketoken"),
                regexp = "Action was successful for the items: faz, bar"
            )
        )
    })
})

# send-6be7e5-POST.json
with_mock_api({
    test_that("pocket_delete - one success, one error", {
        time_stub <- "2020-03-14 12:51:02 CET"
        with_mock(
            Sys.time = function() time_stub,
            expect_warning(
                pocket_delete(item_ids = c("foo", "bar"), consumer_key = "fakekey", access_token = "faketoken"),
                regexp = "Action on bar failed with error: some error occurred"
            )
        )
    })
})