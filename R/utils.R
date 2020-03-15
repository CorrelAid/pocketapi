#' pocket_post_
#' @description internal function to make a POST requests to a Pocket API endpoint.
#' @param endpoint character. endpoint to make a request to.
#' @param consumer_key character. Pocket consumer key.
#' @param access_token character. Pocket access token.
#' @param ... additional named arguments to be put into the body of the POST request.
#' @keywords internal
pocket_post_ <- function(endpoint, consumer_key, access_token, ...) {
  BASE_URL <- "https://getpocket.com/v3/"
  res <- httr::POST(
    glue::glue(BASE_URL, endpoint),
    body = list(
      consumer.key = consumer_key,
      access.token = access_token,
      ...
    )
  )
  return(res)
}

#' @importFrom httr status_code
#' @importFrom glue glue
pocket_stop_for_status_ <- function(res) {
  if (httr::status_code(res) >= 300) {

    status <- res$headers$status
    x_error <- res$headers$`x-error`

    if (is.null(status)) {
      status <- httr::status_code(res)
    }
    stop(glue::glue("Error during API request:
                    {status}: {x_error}"))
  }
}

error_message_consumer_key <- function() {
  return("POCKET_CONSUMER_KEY does not exist as environment variable. Add it to your R environment or manually specify the consumer_key argument.")
}

error_message_access_token <- function() {
  return("POCKET_ACCESS_TOKEN does not exist as environment variable. Add it to your R environment or manually specify the consumer_key argument.")
}

#' collapse_to_comma_separated
#' Create comma separated string
collapse_to_comma_separated_ <- function(v){

  return(paste(v, collapse = ","))

}


#' process_tag_request_
#' Validity checks for tag requests
process_tag_request_ <- function(item_id, action_name, tags) {

  actions <- c("tags_add", "tags_remove", "tags_replace", "tags_clear", "tag_rename", "tag_delete")

  if (!action_name %in% actions) {

    stop("Tag actions can be only be: 'tags_add', 'tags_remove', 'tags_replace', 'tags_clear', 'tag_rename', or 'tag_delete'.")

  }

  if (is.null(item_id) & !action_name %in% c("tag_delete", "tag_rename")) {

    stop("If your action_name is not 'tag_delete' or 'tag_rename', you need to provide an item_id.")

  }

  if (action_name == "tag_delete" & length(tags) > 1) {

    stop("For 'tag_delete', you can only specify an atomic vector of one tag.")

  }

  if (action_name == "tag_rename" & length(tags) != 2) {

    stop("If your action is 'tag_rename', your tags vector must be of length 2, format: c('old tag', 'new tag').")

  }

  if (action_name == "tags_clear" & !is.null(tags)) {

    stop("If your action is 'tags_clear', you must not provide tags.")

  }

}



