#' pocket_delete
#' @description delete items from your Pocket list.
#' @param item_ids character vector. Pocket item ids you want to delete from your list.
#' @param consumer_key character. Your Pocket consumer key. Defaults to Sys.getenv("POCKET_CONSUMER_KEY").
#' @param access_token character. Your Pocket request token. Defaults to Sys.getenv("POCKET_ACCESS_TOKEN").
#' @importFrom purrr map
pocket_delete <- function(item_ids) {
  # generate "array" with actions (list of list in R)
  action_list <- item_ids %>% purrr::map(action_name = "delete", .f = gen_action_)

  # call internal function
  results <- pocket_modify_(action_list)

  return(invisible(results))
}
