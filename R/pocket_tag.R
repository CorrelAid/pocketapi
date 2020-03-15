#' pocket_tag
#' @description modify the tags of the items in pocket.
#' @param item_id atomic character vector. Pocket item id you want to modify the tags for.
#' @param action_name atomic character vector. The kind of tag action you want to undertake.
#' @param tags character vector. The names of the tags to work with the chosen action.
#' @param old_new character vector with two elements. Compulsory if action = rename. First element = old tag, second = new tag.
#' @export
pocket_tag <- function(item_id = NULL, action_name, tags = NULL) {

  # Validity checks & some pre-processing ----
  process_tag_request_(item_id = item_id, action_name = action_name, tags = tags)

    # Processing ----
  pocket_modify_tag_(item_id = item_id, action_name = action_name, tags = tags)

}

#' pocket_modify_tag_
#' @description internal function that sends a request with tag actions to the modify Pocket API endpoint.
#' @param actions list. list of lists where each element is an action object. See https://getpocket.com/developer/docs/v3/modify.
#' @importFrom httr content
#' @importFrom jsonlite toJSON
#' @importFrom purrr map_chr
#' @details see https://getpocket.com/developer/docs/v3/modify.
pocket_modify_tag_ <- function(item_id, action_name, tags) {

  # Execute tag action for "rename" ----
  if (action_name == "tag_rename") {

    # Compile list of lists with action
    action_list <- action_name %>% purrr::map(old_tag = tags[1],
                                              new_tag = tags[2],
                                              .f = pocketapi:::gen_tag_action_)

    # Convert list of lists to JSON
    actions_json <- jsonlite::toJSON(action_list, auto_unbox = TRUE)

    # Send request to Pocket
    res <- pocketapi:::pocket_post_("send",
                                    Sys.getenv("POCKET_CONSUMER_KEY"),
                                    Sys.getenv("POCKET_ACCESS_TOKEN"),
                                    actions = actions_json)

    # Return success message
    if(is.null(pocket_stop_for_status_(res))) {

      print(glue::glue("Successfully renamed tag '{tags[1]}' for '{tags[2]}'."))

    }

  }

  # Execute tag action for four further actions ----
  if (action_name %in% c("tags_replace", "tags_remove", "tags_add", "tags_clear")) {

    # Process tags comma separated string
    tags <- collapse_to_comma_separated_(tags)

    # Compile list of lists with action
    action_list <- item_id %>% purrr::map(action_name = action_name,
                                          tags = tags,
                                          .f = pocketapi:::gen_action_)

    # Send request to pocket
    action_results <- pocket_modify(action_list)

    return(action_results)

  }

  # Execute tag action for "delete"
  if (action_name == "tag_delete") {

    # Compule list of lists for action
    action_list <- action_name %>% purrr::map(tag = tags,
                                              .f = pocketapi:::gen_tag_action_)

    # Convert list of lists to JSON
    actions_json <- jsonlite::toJSON(action_list, auto_unbox = TRUE)

    # Send request to Pocket
    res <- pocketapi:::pocket_post_("send",
                                    Sys.getenv("POCKET_CONSUMER_KEY"),
                                    Sys.getenv("POCKET_ACCESS_TOKEN"),
                                    actions = actions_json)

    # Return success message
    if(is.null(pocket_stop_for_status_(res))) {
      print(glue::glue("Successfully removed tag '{tags}'."))
      }
  }

}


#' gen_tag_action_
#' @description generate an action list element for a given action name
#' @param action_name character. Name of Pocket action as string.
#' @return list
gen_tag_action_ <- function(action_name, ...) {
  return(list(
    action = action_name,
    time = as.POSIXct(Sys.time()),
    ...
  ))
}
