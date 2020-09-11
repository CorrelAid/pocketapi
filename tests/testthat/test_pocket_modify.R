context("pocket_modify utils")

testthat::test_that("successes and failures are extracted correctly from action_results", {
  content_stub <- list(
    action_results = list(TRUE, FALSE),
    action_errors = list(NULL, "some strange error"),
    status = 0
  )
  mockery::stub(extract_action_results_, "httr::content", content_stub)
  action_results <- extract_action_results_(list(), c("a", "b"))
  testthat::expect_length(action_results$success_ids, 1)
  testthat::expect_length(action_results$failure_ids, 1)
  testthat::expect_length(action_results$failures, 1)
})


testthat::test_that("warnings are generated for failures", {
  content_stub <- list(
    action_results = list(TRUE, FALSE),
    action_errors = list(NULL, "some strange error"),
    status = 0
  )
  mockery::stub(extract_action_results_, "httr::content", content_stub)
  action_results <- extract_action_results_(list(), c("a", "b"))
  testthat::expect_warning(warn_for_failures_(action_results$failures),
    regexp = "Action on b failed with error: some strange error"
  )
})
