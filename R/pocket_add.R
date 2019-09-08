
#' pocket_add
#' @description add entry to pocket
#' @param consumer_key character string. Your Pocket consumer key. See https://getpocket.com/developer/docs/authentication.
#' @param access_token character string. Your Pocket request token. See https://getpocket.com/developer/docs/authentication.
#' @param add_url character string. The URL of the item you want to add to your Pocket list.
#' @export
#'
#'
pocket_add <- function(consumer_key, access_token, add_url) {

  if ( missing(consumer_key) ) stop("Argument 'consumer_key' is missing. A valid consumer key for Pocket must be provided. See 'https://getpocket.com/developer/docs/authentication' on how to obtain one.")
  if ( missing(access_token) ) stop("Argument 'access_token' is missing. A valid request token for Pocket must be provided. See 'https://getpocket.com/developer/docs/authentication' on how to obtain one.")
  if ( missing(add_url) )       stop("Argument 'add_url' is missing.")

  pocket_add_url <- httr::parse_url("https://getpocket.com/v3/add")

  res <- httr::POST(pocket_add_url, body = list(consumer.key = consumer_key, access.token = access_token, url=add_url))

  if (res$status_code==400) stop ("Please check the URL of the item you want to add.")
  if (res$status_code==403) stop ("A valid consumer key for Pocket must be provided.")
  if (res$status_code==401) stop ("A valid request token for Pocket must be provided.")
  if (res$status_code==200) message( paste("You added", add_url, "to your pocket list."))

  return(res)

}


