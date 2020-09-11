#' pocket_tag
#' @description modify the tags of the items in pocket.
#' @param action_name character vector. The kind of tag action you want to undertake. Possible values: 'tags_add', 'tags_remove', 'tags_replace', 'tags_clear', 'tag_rename', or 'tag_delete'.
#' @param item_ids character vector. Pocket item ids you want to modify the tags for.
#' @param tags character vector. The names of the tags to work with the chosen action.
#' @param consumer_key character. Your Pocket consumer key. Defaults to Sys.getenv("POCKET_CONSUMER_KEY").
#' @param access_token character. Your Pocket request token. Defaults to Sys.getenv("POCKET_ACCESS_TOKEN").
#' @export
pocket_tag <- function(action_name = c("tags_replace", "tags_remove", "tags_add", "tags_clear"), item_ids = NULL, tags = NULL, consumer_key = Sys.getenv("POCKET_CONSUMER_KEY"),
                       access_token = Sys.getenv("POCKET_ACCESS_TOKEN")) {
  if (consumer_key == "") usethis::ui_stop(error_message_consumer_key())
  if (access_token == "") usethis::ui_stop(error_message_access_token())

  # Validity checks
  stop_for_invalid_tag_action_(item_ids = item_ids, action_name = action_name, tags = tags)

  # Pre-process tags to comma separated string
  tags <- paste(tags, collapse = ",")

  # Processing
  # actions that require item_ids and tags
  if (action_name %in% c("tags_replace", "tags_remove", "tags_add")) {
    action_results <- pocket_modify_bulk_(item_ids, action_name, consumer_key, access_token, tags = tags)
    return(invisible(action_results))
  }

  # clearing all tags from item(s) requires item_ids but not tags
  if (action_name == "tags_clear") {
    action_results <- pocket_modify_bulk_(item_ids, action_name, consumer_key, access_token)
  }

  # renaming a tag requires old name and new name
  if (action_name == "tag_rename") {
    # Compile list of lists with action
    action_list <- action_name %>% purrr::map(
      old_tag = tags[1],
      new_tag = tags[2],
      .f = gen_tag_action_
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
    pocket_stop_for_status_(res)
    usethis::ui_done(glue::glue("Successfully renamed tag '{tags[1]}' for '{tags[2]}'."))
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
      .f = gen_tag_action_
    )

    # Convert list of lists to JSON
    actions_json <- jsonlite::toJSON(action_list, auto_unbox = TRUE)

    res <- pocket_post_("send",
      consumer_key,
      access_token,
      actions = actions_json
    )
    pocket_stop_for_status_(res)
    usethis::ui_done(glue::glue("Successfully removed tag '{tags}'."))
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

stop_for_invalid_tag_action_ <- function(item_ids, action_name, tags) {
  actions <- c("tags_add", "tags_remove", "tags_replace", "tags_clear", "tag_rename", "tag_delete")


  if (!action_name %in% actions) {
    usethis::ui_stop("Tag actions can be only be: 'tags_add', 'tags_remove', 'tags_replace', 'tags_clear', 'tag_rename', or 'tag_delete'.")
  }

  if (is.null(item_ids) & !action_name %in% c("tag_delete", "tag_rename")) {
    usethis::ui_stop("If your action_name is not 'tag_delete' or 'tag_rename', you need to provide at least one item_id.")
  }

  if (action_name == "tag_delete") {
    if (length(tags) > 1) {
      usethis::ui_stop("For 'tag_delete', you can only specify an atomic vector of one tag.")
    }
    if (is.null(tags)) {
      usethis::ui_stop("For 'tag_delete', you need to specify an atomic vector of one tag.")
    }
  }

  if (action_name == "tag_rename" & length(tags) != 2) {
    usethis::ui_stop("If your action is 'tag_rename', your tags vector must be of length 2, format: c('old tag', 'new tag').")
  }

  if (action_name == "tags_clear" & !is.null(tags)) {
    usethis::ui_stop("If your action is 'tags_clear', you must not provide tags.")
  }

  if (action_name == "tags_replace" & is.null(tags)) {
    usethis::ui_stop("For 'tags_replace', you need to specify the tags argument.")
  }
}
