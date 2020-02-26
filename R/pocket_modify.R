#' @description internal function that sends a request with actions to the modify Pocket API endpoint.
#' @param actions list. list of lists where each element is an action object. See https://getpocket.com/developer/docs/v3/modify.
#' @importFrom httr content
#' @importFrom jsonlite toJSON
#' @importFrom purrr map_chr
#' @details see https://getpocket.com/developer/docs/v3/modify.
pocket_modify_ <- function(actions) {
  # auto_unbox because otherwise jsonlite will en-array single values, e.g. ["archive"]
  actions_json <- jsonlite::toJSON(actions, auto_unbox = TRUE)
  res <- pocket_post_("send",
                      Sys.getenv("POCKET_CONSUMER_KEY"),
                      Sys.getenv("POCKET_ACCESS_TOKEN"),
                      actions = actions_json)
  pocket_stop_for_status_(res)

  item_ids <- purrr::map_chr(actions, "item_id")
  action_results <- extract_action_results(res, item_ids)

  message_for_successes_(action_results$success_ids, action_name)
  warn_for_failures_(action_results$failures)

  return(res)
}

#' pocket_modify_bulk_
#' @description bulk modify for a given action, i.e. the action is the same for all item_ids.
#' @param item_ids character vector. Pocket item ids that should be modified.
#' @param action_name character. The action that should be performed on all specified items.
#' @keywords internal
#' @export
pocket_modify_bulk_ <- function(item_ids, action_name) {
  # generate "array" with actions (list of list in R)
  action_list <- item_ids %>% purrr::map(action_name = action_name, .f = gen_action_)

  # call internal function
  res <- pocket_modify_(action_list)

  return(action_results)
}

message_for_successes_ <- function(success_ids, action_name) {
  message(glue::glue("Action {action_name} was successful for the items: {success_ids}"))
}

#' warn_for_failures_
#' @description generate warnings for all failures
#' @param failures list. list of failures.
#' @keywords internal
#' @export
warn_for_failures_ <- function(failures) {
    purrr::walk2(failures, names(failures), function(failure, failure_name) {
      warning(glue::glue("Action on {failure_name} failed with error: {failure$action_errors}"))
    })
}

#' gen_action_
#' @description generate an action list element for a given id and action name
#' @param item_id character. ID of Pocket item
#' @param action_name character. Name of Pocket action as string.
#' @return list
gen_action_ <- function(item_id, action_name, ...) {
  return(list(
    action = action_name,
    item_id = item_id,
    time = as.POSIXct(Sys.time()),
    ...
  ))
}




extract_action_results <- function(res, item_ids) {
  content <- httr::content(res)

  # check whether any action has failed (status == 0)
  if (content$status != 0) {
    return(failure_ids = c(), success_ids = item_ids, failures = list())
  }

  # combine item_ids with action_results and transpose list
  # set item_ids as list  names
  content$status <- NULL
  content_t <- content %>%
    purrr::transpose() %>%
    purrr::set_names(item_ids)

  # get ids where action was successful
  successes <- content_t %>%
    purrr::keep(function(x) x$action_results == TRUE)
  success_ids <- names(successes)

  # get ids where action failed
  failures <- content_t %>%
    purrr::keep(function(x) x$action_results == FALSE)
  failure_ids <- names(failures)

  return(list(success_ids = success_ids, failure_ids = failure_ids, failures = failures))
}



