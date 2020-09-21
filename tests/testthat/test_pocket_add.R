context("pocket_add")

POCKET_TEST_CONSUMER_KEY <- "fakekey"
POCKET_TEST_ACCESS_TOKEN <- "faketoken"

test_that("missing consumer key causes error", {
  expect_error(
    pocket_add(add_url = "xAsdfcm13413", consumer_key = "", access_token = POCKET_TEST_ACCESS_TOKEN),
    regexp = "^POCKET_CONSUMER_KEY does not exist as environment variable.", class = "usethis_error"
  )
})

test_that("missing access token causes error", {
  expect_error(
    pocket_add(add_url = "xAsdfcm13413", consumer_key = POCKET_TEST_CONSUMER_KEY, access_token = ""),
    regexp = "^POCKET_ACCESS_TOKEN does not exist as environment variable.", class = "usethis_error"
  )
})

test_that("missing URL causes error", {
  expect_error(
    pocket_add(),
    regexp = "Argument 'add_urls' is missing."
  )
})

# add-9eee6a-POST.R
test_that("invalid url causes warning that it could not been added", {
    expect_warning(
      pocket_add(
        consumer_key = "dasidadw",
        access_token = POCKET_TEST_ACCESS_TOKEN,
        add_urls = "xAsdfcm13413"
      ),
      regexp = "\n403 Forbidden: The provided keys do not have proper permission", class = "usethis_error"
    )
})

# send-fae745-POST.json
with_mock_api({
  test_that("Valid case", {
      time_stub <- "2020-04-14 12:51:02 CET"
      with_mock(
        Sys.time = function() time_stub,
        {
        result <-
          pocket_add(
            consumer_key = POCKET_TEST_CONSUMER_KEY,
            access_token = POCKET_TEST_ACCESS_TOKEN,
            add_urls = "https://katherinemwood.github.io/post/testthat/",
            success = FALSE)
          expect_equal(result$status_code, 200)
        }
      )
  })
})