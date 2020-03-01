#' pocket_archive
#' @description archive items from your Pocket list.
#' @param item_ids character vector. Pocket item ids you want to archive.
#' @param consumer_key character. Your Pocket consumer key. Defaults to Sys.getenv("POCKET_CONSUMER_KEY").
#' @param access_token character. Your Pocket request token. Defaults to Sys.getenv("POCKET_ACCESS_TOKEN").
#' @importFrom purrr map
#' @export
pocket_archive <- function(item_ids) {
  # generate "array" with actions (list of list in R)
  results <- pocket_modify_bulk_(item_ids, "archive")

  return(invisible(results))
}
