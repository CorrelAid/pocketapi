#' pocket_unfavorite
#' @description unfavorite items from your Pocket list.
#' @param item_ids character vector. Pocket item ids you want to unfavorite
#' @param consumer_key character. Your Pocket consumer key. Defaults to Sys.getenv("POCKET_CONSUMER_KEY").
#' @param access_token character. Your Pocket request token. Defaults to Sys.getenv("POCKET_ACCESS_TOKEN").
#' @details This function uses the \code{modify} endpoint of the Pocket API which exhibits some weird behaviour. 
#' For example, even if a `modify` action is not successful, the API will still return "success". 
#' See [issue [#26](https://github.com/CorrelAid/pocketapi/issues/26) for a discussion. 
#' @importFrom purrr map
#' @export
pocket_unfavorite <- function(item_ids, consumer_key = Sys.getenv("POCKET_CONSUMER_KEY"),
                              access_token = Sys.getenv("POCKET_ACCESS_TOKEN")) {
  if (consumer_key == "") stop(error_message_consumer_key())
  if (access_token == "") stop(error_message_access_token())

  # generate "array" with actions (list of list in R)
  results <- pocket_modify_bulk_(item_ids, "unfavorite", consumer_key, access_token)

  return(invisible(results))
}
