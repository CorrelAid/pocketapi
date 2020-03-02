#' pocket_tag
#' @description modify the tags of the items in pocket.
#' @param item_id atomic character vector. Pocket item id you want to modify the tags for.
#' @param action_name atomic character vector. The kind of tag action you want to undertake.
#' @param tags character vector. The names of the tags to work with the chosen action.
#' @param old_new character vector with two elements. Compulsory if action = rename. First element = old tag, second = new tag.
#' @importFrom purrr map

pocket_tag <- function(item_id = NULL, action_name, tags = NULL, old_new = NULL) {

  # check for validity
  actions <- c("tags_add", "tags_remove", "tags_replace", "tags_clear", "tag_rename", "tag_delete")

  # has tags: add, remove, replace
  # has only one tag: delete
  # has exactly two tags: rename
  # has no tags: clear

    if (!action_name %in% actions) {

    stop("Tag actions can be only be: 'tags_add', 'tags_remove', 'tags_replace', 'tags_clear', 'tag_rename', or 'tag_delete'.")
    }

  if (is.null(idem_id) & action_name != "tag_delete") {

    stop("If your action_name is not 'tag_delete', you need to provide an item_id.")

  }

  if (action_name == "tag_delete" & length(tags) > 1) {

    stop("For tag_delete, you can only specify an atomic vector of one tag.")

  }

  tags <- collapse_to_comma_separated(tags)

  if (action_name == "tags_clear") {tags <- NULL}

  if (action_name == "tag_rename" & length(old_new) != 2) {

    stop("If your action is 'rename', you need to provide a vector for 'old_new', format: c('old tag', 'new tag').")

  } else {

    old_tag <- old_new[1]

    new_tag <- old_new[2]

  }


  if (action_name == "tag_rename") {

    action_list <- item_id %>% purrr::map(action_name = action_name,
                                          old_tag = old_tag,
                                          new_tag = new_tag,
                                          .f = pocketapi:::gen_action_)

  }

  if (action_name %in% c("tags_replace", "tags_remove", "tags_add", "tag_delete") ) {

    action_list <- item_id %>% purrr::map(action_name = action_name,
                                          tags = tags,
                                          .f = pocketapi:::gen_action_)

    }

  action_results <- pocket_modify(action_list)

  return(action_results)

}
