
pocket_modify_ <- function(action_list) {
  # we can send multiple actions
  # see https://getpocket.com/developer/docs/v3/modify
  return(pocket_post_("send",
               Sys.getenv("POCKET_CONSUMER_KEY"),
               Sys.getenv("POCKET_ACCESS_TOKEN"),
               action_list))
}

# actions that only require item id
# archive
# readd
# favorite
# unfavorite


# tagging action


gen_action_ <- function(item_id, action_name, ...) {
  return(list(
    action = action_name,
    item_id = item_id,
    time = as.POSIXct(Sys.time()),
    ...
  ))
}



