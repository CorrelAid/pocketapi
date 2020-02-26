#' pocket_add
#' @description add an entry to pocket
#' @param add_url character string. The URL of the item you want to add to your Pocket list.
#' @param consumer_key character string. Your Pocket consumer key. Defaults to Sys.getenv("POCKET_CONSUMER_KEY").
#' @param access_token character string. Your Pocket request token. Defaults to Sys.getenv("POCKET_ACCESS_TOKEN").
#' @export
#' @return the response from the httr call, invisibly
#'
#'
pocket_add <-
  function(add_url,
           consumer_key = Sys.getenv("POCKET_CONSUMER_KEY"),
           access_token = Sys.getenv("POCKET_ACCESS_TOKEN")) {
    if (missing(add_url)) stop("Argument 'add_url' is missing.")
    if (consumer_key == "") stop(error_message_consumer_key())
    if (access_token == "") stop(error_message_access_token())



    res <- pocket_post_("add", consumer_key, access_token, url = add_url)

    pocket_stop_for_status_(res)

    invisible(res)
  }
