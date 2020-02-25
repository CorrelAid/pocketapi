

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
    if (consumer_key == "")
      stop(
        "POCKET_CONSUMER_KEY does not exist as environment variable. Add it to your R environment or manually specify the consumer_key argument."
      )
    if (access_token == "")
      stop(
        "POCKET_ACCESS_TOKEN does not exist as environment variable. Add it to your R environment or manually specify the access_token argument. See ?get_access_token for details."
      )
    if (missing(add_url))
      stop("Argument 'add_url' is missing.")


    res <- pocket_post_("add", consumer_key, access_token, url = add_url)

    if (res$status_code == 400)
      stop ("Please check the URL of the item you want to add.")
    if (res$status_code == 403)
      stop ("A valid consumer key for Pocket must be provided.")
    if (res$status_code == 401)
      stop ("A valid request token for Pocket must be provided.")
    if (res$status_code == 200)
      message(paste("You added", add_url, "to your pocket list."))

    invisible(res)

  }
