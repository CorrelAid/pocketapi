context("pocket_archive")

# send-2069e8-POST.json
with_mock_api({
    test_that("success generates message", {
        time_stub <- "2020-03-14 12:51:02 CET"
        # depth = 3 because gen_action_ is called further down
        mockery::stub(gen_action_, "Sys.time", time_stub, depth = 2)
        expect_message(
            pocket_archive(item_ids = c("foobarid"), consumer_key = "fakekey", access_token = "faketoken"),
            regexp = "Action was successful"
        )
    })
})



# send-11e8e0-POST.json
with_mock_api({
    test_that("one success, one error", {
        time_stub <- "2020-03-14 12:51:02 CET"
        # depth = 3 because gen_action_ is called further down
        mockery::stub(gen_action_, "base::Sys.time", time_stub, depth = 2)
        expect_warning(
            pocket_archive(item_ids = c("foo", "bar"), consumer_key = "fakekey", access_token = "faketoken"),
            regexp = "Action on bar failed with error: some error occurred"
        )
    })
})