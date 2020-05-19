context("pocket_tag")


test_that("empty consumer key causes error", {
    expect_error(pocket_tag("tags_remove",
        access_token = "myaccesstoken", consumer_key = "",
    ),
    regexp = "^POCKET_CONSUMER_KEY does not exist as environment variable. "
    )
})


test_that("empty access token causes error", {
    expect_error(pocket_tag("tags_remove",
        access_token = "", consumer_key = "myconsumerkey",
    ),
    regexp = "^POCKET_ACCESS_TOKEN does not exist as environment variable"
    )
})

test_that("pocket_tag throws error for invalid action type", {
    expect_error(pocket_tag("tag_remove", consumer_key = "myconsumerkey", access_token = "myaccesstoken"), # it's tags_remove
        regexp = "Tag actions can be only be: 'tags_add', 'tags_remove', 'tags_replace', 'tags_clear', 'tag_rename', or 'tag_delete'."
    )
})

# tags_add
# send-44b5bc-POST.json
with_mock_api({
    test_that("pocket_tag tags_add - two successes", {
        time_stub <- "2020-04-14 12:51:02 CET"
        with_mock(
            Sys.time = function() time_stub,
            expect_message(pocket_tag("tags_add", c("3424323", "3423222"), tags = c("r", "hadley"), consumer_key = "myconsumerkey", access_token = "myaccesstoken"),
                regexp = "Action was successful"
            )
        )
    })
})

# tags_remove
# send-4dda31-POST.json
with_mock_api({
    test_that("pocket_tag tags_remove - two successes", {
        time_stub <- "2020-04-14 12:51:02 CET"
        with_mock(
            Sys.time = function() time_stub,
            expect_message(pocket_tag("tags_remove", c("3424323", "3423222"), tags = c("r", "hadley"), consumer_key = "myconsumerkey", access_token = "myaccesstoken"),
                regexp = "Action was successful"
            )
        )
    })
})

# tags_clear
test_that("pocket_tag tags_clear - throw error if tags are provided", {
    expect_error(pocket_tag("tags_clear", c("3424323", "3423222"), tags = c("foo", "hadley"), consumer_key = "myconsumerkey", access_token = "myaccesstoken"),
        regexp = "If your action is 'tags_clear', you must not provide tags."
    )
})

# send-49cc63-POST.json
with_mock_api({
    test_that("pocket_tag tags_clear - two successes", {
        time_stub <- "2020-04-14 12:51:02 CET"
        with_mock(
            Sys.time = function() time_stub,
            expect_message(pocket_tag("tags_clear", c("3424323", "3423222"), consumer_key = "myconsumerkey", access_token = "myaccesstoken"),
                regexp = "Action was successful"
            )
        )
    })
})

# tags_replace
test_that("pocket_tag tags_replace - throw error if no tags provided", {
    expect_error(pocket_tag("tags_replace", c("3424323", "3423222"), consumer_key = "myconsumerkey", access_token = "myaccesstoken"),
        regexp = "For 'tags_replace', you need to specify the tags argument."
    )
})

# send-53161a-POST.json
with_mock_api({
    test_that("pocket_tag tags_replace - two successes", {
        time_stub <- "2020-04-14 12:51:02 CET"
        with_mock(
            Sys.time = function() time_stub,
            expect_message(pocket_tag("tags_replace", c("3424323", "3423222"), tags = c("hadley"), consumer_key = "myconsumerkey", access_token = "myaccesstoken"),
                regexp = "Action was successful for the items: 3424323, 3423222"
            )
        )
    })
})


# tag_delete
test_that("pocket_tag tags_delete - throw error if more than one tag provided", {
    expect_error(pocket_tag("tag_delete", tag = c("jenny", "hadley"), consumer_key = "myconsumerkey", access_token = "myaccesstoken"),
        regexp = "For 'tag_delete', you can only specify an atomic vector of one tag."
    )
})

# send-2c60b2-POST.json
with_mock_api({
    test_that("pocket_tag tag_delete - success", {
        time_stub <- "2020-04-14 12:51:02 CET"
        with_mock(
            Sys.time = function() time_stub,
            expect_message(pocket_tag("tag_delete", tags = c("hadley"), consumer_key = "myconsumerkey", access_token = "myaccesstoken"),
                regexp = "Successfully removed tag 'hadley'"
            )
        )
    })
})