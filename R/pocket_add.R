#' pocket_add
#' @description Add one or more items to your Pocket account.
#' @param add_urls Character vector. The URL or URLs you want to add to your Pocket list.
#' @param item_ids Character vector. The item_ids of the items you want to add. Defaults to empty character vector.
#' @param tags Character vector. One or more tags to be applied to all of the newly added URLs. Defaults to NULL.
#' @param success Logical. Enables success/failure messages for every URL. Defaults to TRUE. Needs GET permission if TRUE.
#' @param consumer_key Character string. Your Pocket consumer key. Defaults to \code{Sys.getenv("POCKET_CONSUMER_KEY")}.
#' @param access_token Character string. Your Pocket request token. Defaults to \code{Sys.getenv("POCKET_ACCESS_TOKEN")}.
#' @export
#' @details This function uses the \code{modify} endpoint of the Pocket API which exhibits some weird behaviour. 
#' For example, even if a `modify` action is not successful, the API will still return "success". 
#' See [issue [#26](https://github.com/CorrelAid/pocketapi/issues/26) for a discussion. 
#' @return the response from the httr call, invisibly
pocket_add <- function(add_urls,
                       item_ids = "",
                       tags = NULL,
                       success = TRUE,
                       consumer_key = Sys.getenv("POCKET_CONSUMER_KEY"),
                       access_token = Sys.getenv("POCKET_ACCESS_TOKEN")) {

  if (consumer_key == "") usethis::ui_stop(error_message_consumer_key())
  if (access_token == "") usethis::ui_stop(error_message_access_token())
  if (missing(add_urls)) usethis::ui_stop("Argument 'add_urls' is missing.")

  action_list <- add_urls %>% purrr::map(
    action_name = "add",
    item_id = item_ids,
    tags = paste(tags, collapse = ","),
    .f = gen_add_action_)

    actions_json <- jsonlite::toJSON(action_list, auto_unbox = TRUE)

    res <- pocket_post_("send",
                        consumer_key,
                        access_token,
                        actions = actions_json
    )

    if (success == TRUE) {
      check_for_add_success_(add_urls, consumer_key, access_token)
    }

  return(invisible(res))

}

#' check_for_add_success_
#' @description Check whether all URLs were successfully added to Pocket by \code{pocket_add()}.
#' @param urls Character vector containing URLs to be checked.
#' @param consumer_key Character string. Your Pocket consumer key.
#' @param access_token Character string. Your Pocket request token.
#' @return Returns messages of success and/or failure of the URLs wished to be added to Pocket.
#' @keywords internal
check_for_add_success_ <- function(urls, consumer_key, access_token) {

  pocket_content <- pocketapi::pocket_get(consumer_key  = consumer_key, access_token = access_token)

  checked <- urls %in% pocket_content$given_url

  false_indexes <- which(checked %in% FALSE)
  true_indexes <- which(checked %in% TRUE)

  false_urls <- urls[false_indexes]
  true_urls <- urls[true_indexes]

    if (!is.null(true_urls)) {

    print(glue::glue("The following URL has been successfully added: {true_urls}."))

    }

    if (!is.null(false_urls)) {

    warning(glue::glue("The following URL has not been successfully added: {false_urls}. Hint: URLs need to begin with 'http://' or 'https://'."))

    }

}


#' gen_add_action_
#' @description Generate an action list element for adding URLs to Pocket.
#' @param add_urls Character vector. URLs that are to be added to Pocket.
#' @param action_name Character. Name of the action to be used (ADD, in this case).
#' @param ... Additional named arguments to be added to the action list.
#' @return List of actions and URLs to add to Pocket.
#' @keywords internal
gen_add_action_ <- function(add_urls, action_name, ...) {
  return(list(
    action = action_name,
    url = add_urls,
    ...
  ))
}


# #' extract_action_no_id_results_
# #' #' @description Generate an action list element for a given action name
# #' #' @param add_urls character vector. URLs that are to be added
# #' @param action_name character. Name of the action to be used (add)
# #' @param ... additional named arguments to be added to the action list.
# #' @return list
# extract_action_no_id_results_ <- function(res) {
#
#   content <- httr::content(res)
#
#   success_ids <- map(content$action_results, "item_id")
#   failure_ids <- map(content$action_errors, "item_id")
#
#   return(list(success_ids = success_ids, failure_ids = failure_ids))
# }

