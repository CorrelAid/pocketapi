#' pocket_add
#' @description add one or more items to Pocket
#' @param add_urls character vector. The URL or URLs you want to add to your Pocket list.
#' @param item_ids character vector. (Optional) The item_ids of the items you want to add.
#' @param tags character vector. One or more tags to be applied to any of the newly added URLs.
#' @param success logical. Enables success/failure messages for each URL. Defaults to TRUE.
#' @param consumer_key character string. Your Pocket consumer key. Defaults to Sys.getenv("POCKET_CONSUMER_KEY").
#' @param access_token character string. Your Pocket request token. Defaults to Sys.getenv("POCKET_ACCESS_TOKEN").
#' @export
#' @return the response from the httr call, invisibly
pocket_add <- function(add_urls,
                       item_ids = "",
                       tags = NULL,
                       success = TRUE,
                       consumer_key = Sys.getenv("POCKET_CONSUMER_KEY"),
                       access_token = Sys.getenv("POCKET_ACCESS_TOKEN")) {

  if (consumer_key == "") stop(error_message_consumer_key())
  if (access_token == "") stop(error_message_access_token())
  if (missing(add_urls)) stop("Argument 'add_urls' is missing.")

  action_list <- add_urls %>% purrr::map(
    action_name = "add",
    item_id = item_ids,
    tags = paste(tags, collapse = ","),
    .f = pocketapi:::gen_add_action_)

    actions_json <- jsonlite::toJSON(action_list, auto_unbox = TRUE)

    res <- pocketapi:::pocket_post_("send",
                        consumer_key,
                        access_token,
                        actions = actions_json
    )

    if (success == TRUE) {
    check_for_add_success_(add_urls)
    }

  return(invisible(res))

}

#' check_for_add_success_
#' @description check whether all urls were successfully added to Pocket
#' @param urls character vector containing URLs to be checked
#' @param ... additional named arguments to be added to the action list.
#' @return logical
check_for_add_success_ <- function(urls) {

  pocket_content <- pocketapi::pocket_get()

  checked <- urls %in% pocket_content$given_url

  false_indexes <- which(checked %in% FALSE)
  true_indexes <- which(checked %in% TRUE)

  false_urls <- urls[false_indexes]
  true_urls <- urls[true_indexes]

    if (!is.null(true_urls)) {

    print(glue::glue("The following URL has been successfully added: {true_urls}."))

    }

    if (!is.null(false_urls)) {

    print(glue::glue("The following URL has not been successfully added: {false_urls}. Hint: URLs need to begin with 'http://' or 'https://'."))

    }

}


#' gen_add_action_
#' @description generate an action list element for a given action name
#' @param add_urls character vector. URLs that are to be added
#' @param action_name character. Name of the action to be used (add)
#' @param ... additional named arguments to be added to the action list.
#' @return list
gen_add_action_ <- function(add_urls, action_name, ...) {
  return(list(
    action = action_name,
    url = add_urls,
    ...
  ))
}


#' extract_action_no_id_results_
#' @description generate an action list element for a given action name
#' @param add_urls character vector. URLs that are to be added
#' @param action_name character. Name of the action to be used (add)
#' @param ... additional named arguments to be added to the action list.
#' @return list
extract_action_no_id_results_ <- function(res) {

  content <- httr::content(res)

  success_ids <- map(content$action_results, "item_id")
  failure_ids <- map(content$action_errors, "item_id")

  return(list(success_ids = success_ids, failure_ids = failure_ids))
}

