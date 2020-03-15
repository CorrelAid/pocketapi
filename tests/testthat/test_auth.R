context("authorization related functions")

test_that("create_authorize_url works as expected", {
    url <- create_authorize_url("reqtokengibberish")
    expect_equal(url, "https://getpocket.com/auth/authorize?request_token=reqtokengibberish&redirect_uri=https://github.com/CorrelAid/pocketapi")
})

test_that("create_authorize_url throws error for invalid request_token argument", {
    expect_error(create_authorize_url(33212), "Argument request_token must be a character vector of length 1.")
    expect_error(create_authorize_url(c("foo", "bar")), "Argument request_token must be a character vector of length 1.")
})


# request-b9df5b-POST.R
with_mock_api({
    test_that("get_request_token throws 400 error for invalid consumer_key", {
        expect_error(get_request_token("invalidconsumerkey"), regexp = "403 Forbidden: Invalid consumer key.")
    })
})

# request-da037e-POST.R
with_mock_api({
    test_that("get_request_token valid case", {
        request_token <- get_request_token("myconsumerkey")
        expect_equal(request_token, "successrequesttokenyey")
    })
})

# authorize-7becba-POST.R
with_mock_api({
    test_that("get_access_token throws 403 error for invalid consumer_key", {
        expect_error(get_access_token("invalidconsumerkey", "myrequesttoken"), regexp = "403 Forbidden: Invalid consumer key")
    })
})

# authorize-1384bf-POST.R
with_mock_api({
    test_that("get_access_token throws 400 error for invalid request_token", {
        expect_error(get_access_token("myconsumerkey", "invalidrequesttoken"), regexp = "400 Bad Request: Code not found.")
    })
})

# authorize-b9d4e4-POST.R
with_mock_api({
    test_that("get_access_token valid case", {
        access_token <- get_access_token("myconsumerkey", "myrequesttoken")
        expect_equal(access_token, "successfullaccesstokenyey")
    })
})