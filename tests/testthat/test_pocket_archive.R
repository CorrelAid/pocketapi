context("pocket_archive")

POCKET_TEST_CONSUMER_KEY <- Sys.getenv("POCKET_TEST_CONSUMER_KEY")
POCKET_TEST_ACCESS_TOKEN <- Sys.getenv("POCKET_TEST_ACCESS_TOKEN")


with_mock_api({
    test_that("missing consumer key causes error", {
        expect_error(
            pocket_archive(item_ids = c("foobarid"), consumer_key = POCKET_TEST_CONSUMER_KEY, access_token = POCKET_TEST_ACCESS_TOKEN),
            regexp = "^POCKET_CONSUMER_KEY does not exist as environment variable."
        )
    })
})