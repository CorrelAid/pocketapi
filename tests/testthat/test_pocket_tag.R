context("pocket_tag")


test_that("pocket_tag throws error for invalid action type", {
    expect_error(pocket_tag("tag_remove"), # it's tags_remove
        regexp = "Tag actions can be only be: 'tags_add', 'tags_remove', 'tags_replace', 'tags_clear', 'tag_rename', or 'tag_delete'."
    )
})

