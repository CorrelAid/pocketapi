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

# send-80718d-POST.json
with_mock_api({
    test_that("pocket_tag tags_add - two successes", {
        time_stub <- "2020-03-14 12:51:02 CET"
        with_mock(
            Sys.time = function() time_stub,
            expect_message(pocket_tag("tags_add", c("3424323", "3423222")), regexp = "Action was successful for the items: 3424323, 3423222")
        )
    })
})