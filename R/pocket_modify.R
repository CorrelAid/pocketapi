#' pocket_modify
#' @description Function that sends a request with a list of actions to the 'modify' Pocket API endpoint.
#' @param actions List. List of lists where each element is an action object. See https://getpocket.com/developer/docs/v3/modify.
#' @param consumer_key Character string. Your Pocket consumer key. Defaults to \code{Sys.getenv("POCKET_CONSUMER_KEY")}.
#' @param access_token Character string. Your Pocket request token. Defaults to \code{Sys.getenv("POCKET_ACCESS_TOKEN")}.
#' @importFrom httr content
#' @importFrom jsonlite toJSON
#' @importFrom purrr map_chr
#' @details see https://getpocket.com/developer/docs/v3/modify. This function uses the \code{modify} endpoint of the Pocket API which exhibits some weird behaviour. 
#' For example, even if a `modify` action is not successful, the API will still return "success". 
#' See [issue [#26](https://github.com/CorrelAid/pocketapi/issues/26) for a discussion. 
#' @export
pocket_modify <- function(actions, consumer_key = Sys.getenv("POCKET_CONSUMER_KEY"),
                          access_token = Sys.getenv("POCKET_ACCESS_TOKEN")) {
  if (consumer_key == "") usethis::ui_stop(error_message_consumer_key())
  if (access_token == "") usethis::ui_stop(error_message_access_token())

  # Set auto_unbox = TRUE because otherwise jsonlite will en-array single values, e.g. ["archive"]
  actions_json <- jsonlite::toJSON(actions, auto_unbox = TRUE)
  res <- pocket_post_("send",
    consumer_key,
    access_token,
    actions = actions_json
  )
  pocket_stop_for_status_(res)

  item_ids <- purrr::map_chr(actions, "item_id")
  action_results <- extract_action_results_(res, item_ids)

  message_for_successes_(action_results$success_ids)
  warn_for_failures_(action_results$failures)

  return(action_results)
}

#' pocket_modify_bulk_
#' @description Bulk modify for a given action, i.e., the action is the same for all item_ids.
#' @param item_ids Character vector. Pocket item IDs that should be modified.
#' @param action_name Character. The action that should be performed on all specified items.
#' @param consumer_key Character string. Your Pocket consumer key. Defaults to \code{Sys.getenv("POCKET_CONSUMER_KEY")}.
#' @param access_token Character string. Your Pocket request token. Defaults to \code{Sys.getenv("POCKET_ACCESS_TOKEN")}.
#' @param ... Additional named arguments to be added to the action list items.
#' @importFrom purrr map
#' @keywords internal
pocket_modify_bulk_ <- function(item_ids, action_name, consumer_key, access_token, ...) {

  # Generate "array" with actions (list of list in R)
  action_list <- item_ids %>% purrr::map(action_name = action_name, .f = gen_action_, ...)

  # Call internal function
  action_results <- pocket_modify(action_list, consumer_key, access_token)

  return(action_results)
}

message_for_successes_ <- function(success_ids) {
  success_ids_collapsed <- paste(success_ids, collapse = ", ")
  usethis::ui_done(glue::glue("Action was successful for the items: {success_ids_collapsed}"))
}

#' warn_for_failures_
#' @description Generate warnings for all failures.
#' @param failures List of failures.
#' @keywords internal
warn_for_failures_ <- function(failures) {
  purrr::walk2(failures, names(failures), function(failure, failure_name) {
    usethis::ui_warn(glue::glue("Action on {failure_name} failed with error: {failure$action_errors}"))
  })
}

#' gen_action_
#' @description Generate a Pocket action list element for a given ID and action name.
#' @param item_id Character. ID of Pocket item.
#' @param action_name Character. Name of Pocket action as a string.
#' @param ... Additional, named arguments to be added to the action list.
#' @return List representing a Pocket API action.
#' @keywords internal
gen_action_ <- function(item_id, action_name, ...) {
  return(list(
    action = action_name,
    item_id = item_id,
    time = as.POSIXct(Sys.time()),
    ...
  ))
}

#' extract_action_results_
#' @description Extract results from list that is returned by the send endpoint of the Pocket API.
#' @param res List. Httr response object.
#' @param item_ids Character vector. Pocket item IDs that were modified.
#' @return Named list with the IDs for which the action was successful, the ids for which it failed and the list of failures.
#' @keywords internal
extract_action_results_ <- function(res, item_ids) {
  content <- httr::content(res)

  # Check whether any action has failed (status == 0)
  if (content$status != 0) {
    return(list(failure_ids = c(), success_ids = item_ids, failures = list()))
  }

  # Combine item_ids with action_results and transpose list
  # Set item_ids as list names
  content$status <- NULL
  content_t <- content %>%
    purrr::transpose() %>%
    purrr::set_names(item_ids)

  # Get IDs where action was successful
  successes <- content_t %>%
    purrr::keep(function(x) x$action_results == TRUE)
  success_ids <- names(successes)

  # Get IDs where action failed
  failures <- content_t %>%
    purrr::keep(function(x) x$action_results == FALSE)
  failure_ids <- names(failures)

  return(list(success_ids = success_ids, failure_ids = failure_ids, failures = failures))
}
