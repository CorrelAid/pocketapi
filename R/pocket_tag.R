#' pocket_tag
#' @description modify the tags of the items in pocket.
#' @param action_name character vector. The kind of tag action you want to undertake. Possible values: 'tags_add', 'tags_remove', 'tags_replace', 'tags_clear', 'tag_rename', or 'tag_delete'.
#' @param item_ids character vector. Pocket item ids you want to modify the tags for.
#' @param tags character vector. The names of the tags to work with the chosen action.
#' @param consumer_key character. Your Pocket consumer key. Defaults to Sys.getenv("POCKET_CONSUMER_KEY").
#' @param access_token character. Your Pocket request token. Defaults to Sys.getenv("POCKET_ACCESS_TOKEN").
#' @export
pocket_tag <- function(action_name, item_ids = NULL, tags = NULL, consumer_key = Sys.getenv("POCKET_CONSUMER_KEY"),
                       access_token = Sys.getenv("POCKET_ACCESS_TOKEN")) {
  if (consumer_key == "") stop(error_message_consumer_key())
  if (access_token == "") stop(error_message_access_token())

  # Pre-process tags to comma separated string
  tags <- paste(tags, collapse = ",")

  # Validity checks
  stop_for_invalid_tag_action_(item_ids = item_ids, action_name = action_name, tags = tags, old_new = old_new)

  # Processing
  if (action_name %in% c("tags_replace", "tags_remove", "tags_add", "tags_clear")) {
    action_list <- item_ids %>% purrr::map(
      action_name = action_name,
      tags = tags,
      .f = gen_action_
    )

    action_results <- pocket_modify(action_list)

    return(invisible(action_results))
  }

  if (action_name == "tag_rename") {

    # Compile list of lists with action
    action_list <- action_name %>% purrr::map(
      old_tag = tags[1],
      new_tag = tags[2],
      .f = pocketapi:::gen_tag_action_
    )

    # Convert list of lists to JSON
    actions_json <- jsonlite::toJSON(action_list, auto_unbox = TRUE)

    # Send request to Pocket
    res <- pocket_post_("send",
      consumer_key,
      access_token,
      actions = actions_json
    )

    # Return success message
    if (is.null(pocket_stop_for_status_(res))) {
      print(glue::glue("Successfully renamed tag '{tags[1]}' for '{tags[2]}'."))
    }
  }


  # Execute tag action for "delete"
  if (action_name == "tag_delete") {
    action_list <- action_name %>% purrr::map(
      tag = tags,
      .f = gen_tag_action_
    )

    # Compule list of lists for action
    action_list <- action_name %>% purrr::map(
      tag = tags,
      .f = pocketapi:::gen_tag_action_
    )

    # Convert list of lists to JSON
    actions_json <- jsonlite::toJSON(action_list, auto_unbox = TRUE)

    res <- pocket_post_("send",
      consumer_key,
      access_token,
      actions = actions_json
    )
    pocket_stop_for_status_(res)
    message(glue::glue("Successfully removed tag '{tags}'."))
  }
}



#' gen_tag_action_
#' @description generate an action list element for a given action name
#' @param action_name character. Name of Pocket action as string.
#' @param ... additional named arguments to be added to the action list.
#' @return list
gen_tag_action_ <- function(action_name, ...) {
  return(list(
    action = action_name,
    time = as.POSIXct(Sys.time()),
    ...
  ))
}



stop_for_invalid_tag_action_ <- function(item_ids, action_name, tags, old_new) {
  actions <- c("tags_add", "tags_remove", "tags_replace", "tags_clear", "tag_rename", "tag_delete")


  if (!action_name %in% actions) {
    stop("Tag actions can be only be: 'tags_add', 'tags_remove', 'tags_replace', 'tags_clear', 'tag_rename', or 'tag_delete'.")
  }

  if (is.null(item_ids) & !action_name %in% c("tag_delete", "tag_rename")) {
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