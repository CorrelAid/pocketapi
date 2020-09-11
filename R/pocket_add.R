#' pocket_add
#' @description add an entry to pocket
#' @param add_url character string. The URL of the item you want to add to your Pocket list.
#' @param consumer_key character string. Your Pocket consumer key. Defaults to Sys.getenv("POCKET_CONSUMER_KEY").
#' @param access_token character string. Your Pocket request token. Defaults to Sys.getenv("POCKET_ACCESS_TOKEN").
#' @export
#' @details This function uses the \code{modify} endpoint of the Pocket API which exhibits some weird behaviour. 
#' For example, even if a `modify` action is not successful, the API will still return "success". 
#' See [issue [#26](https://github.com/CorrelAid/pocketapi/issues/26) for a discussion. 
#' @return the response from the httr call, invisibly
#'
#'
pocket_add <-
  function(add_url,
           consumer_key = Sys.getenv("POCKET_CONSUMER_KEY"),
           access_token = Sys.getenv("POCKET_ACCESS_TOKEN")) {
    if (missing(add_url)) usethis::ui_stop("Argument 'add_url' is missing.")
    if (consumer_key == "") usethis::ui_stop(error_message_consumer_key())
    if (access_token == "") usethis::ui_stop(error_message_access_token())



    res <- pocket_post_("add", consumer_key, access_token, url = add_url)

    pocket_stop_for_status_(res)

    invisible(res)
  }
