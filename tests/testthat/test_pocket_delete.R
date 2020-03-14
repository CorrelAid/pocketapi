context("pocket_archive")

# send-2069e8-POST.json
with_mock_api({
    test_that("success generates message", {
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


# send-e0dfab-POST.json
with_mock_api({
    test_that("two successes", {
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

# send-11e8e0-POST.json
with_mock_api({
    test_that("one success, one error", {
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