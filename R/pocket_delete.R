#' pocket_delete
#' @description delete items from your Pocket list.
#' @param item_ids character vector. Pocket item ids you want to delete from your list.
#' @param consumer_key character. Your Pocket consumer key. Defaults to Sys.getenv("POCKET_CONSUMER_KEY").
#' @param access_token character. Your Pocket request token. Defaults to Sys.getenv("POCKET_ACCESS_TOKEN").
#' @importFrom purrr map
pocket_delete <- function(item_ids) {
  action_list <- item_ids %>% purrr::map(action_name = "delete", .f = gen_action_)
  res <- pocket_modify_(action_list)
  httr::stop_for_status(res)

  message(glue::glue("You deleted the following items from your Pocket list: {item_ids}"))
  return(invisible(res))
}
