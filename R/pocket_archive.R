#' pocket_archive
#' @description Archive items from your Pocket list.
#' @param item_ids Character vector. Pocket item IDs you want to archive. Get them, e.g., via \code{pocket_get}.
#' @param consumer_key Character. Your Pocket consumer key. Defaults to \code{Sys.getenv("POCKET_CONSUMER_KEY")}.
#' @param access_token Character. Your Pocket request token. Defaults to \code{Sys.getenv("POCKET_ACCESS_TOKEN")}.
#' @importFrom purrr map
#' @return Invisibly returns a list containing information on whether the action failed or succeeded, including the respective item ID.
#' @export
pocket_archive <- function(item_ids, consumer_key = Sys.getenv("POCKET_CONSUMER_KEY"),
                           access_token = Sys.getenv("POCKET_ACCESS_TOKEN")) {

   if (consumer_key == "") stop(error_message_consumer_key())
  if (access_token == "") stop(error_message_access_token())

  # Generate "array" with actions (list of list in R)
  results <- pocket_modify_bulk_(item_ids, "archive", consumer_key, access_token)

  return(invisible(results))
}

