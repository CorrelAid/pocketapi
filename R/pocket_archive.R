#' pocket_archive
#' @description archive items from your Pocket list.
#' @param item_ids character vector. Pocket item ids you want to archive.
#' @param consumer_key character. Your Pocket consumer key. Defaults to Sys.getenv("POCKET_CONSUMER_KEY").
#' @param access_token character. Your Pocket request token. Defaults to Sys.getenv("POCKET_ACCESS_TOKEN").
#' @importFrom purrr map
#' @export
pocket_archive <- function(item_ids, consumer_key = Sys.getenv("POCKET_CONSUMER_KEY"),
                           access_token = Sys.getenv("POCKET_ACCESS_TOKEN")) {
  if (consumer_key == "") usethis::ui_stop(error_message_consumer_key())
  if (access_token == "") usethis::ui_stop(error_message_access_token())

  # generate "array" with actions (list of list in R)
  results <- pocket_modify_bulk_(item_ids, "archive", consumer_key, access_token)

  return(invisible(results))
}
