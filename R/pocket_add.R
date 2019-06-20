
#' pocket_add
#' @description add entry to pocket
#' @param consumer.key character string. Your Pocket consumer key. See https://getpocket.com/developer/docs/authentication.
#' @param access.token character string. Your Pocket request token. See https://getpocket.com/developer/docs/authentication.
#' @param add.url character string. The URL of the item you want to add to your Pocket list.
#' @export
#' 
#'

library(httr)


pocket_add <- function(consumer.key=NULL, access.token=NULL, add.url=NULL) {
  
  if ( is.null(consumer.key) ) stop("Argument 'consumer.key' is missing. A valid consumer key for Pocket must be provided. See 'https://getpocket.com/developer/docs/authentication' on how to obtain one.")
  if ( is.null(access.token) ) stop("Argument 'access.token' is missing. A valid request token for Pocket must be provided. See 'https://getpocket.com/developer/docs/authentication' on how to obtain one.")
  if ( is.null(add.url) )       stop("Argument 'add.url' is missing.")
  
  pocket_add_url <- httr::parse_url("https://getpocket.com/v3/add")

  res <- httr::POST(pocket_add_url, body = list(consumer_key = consumer.key, access_token = access.token, url=add.url))
  
  # status_code Fehlermeldungen nur nach rumprobieren mit "falschen" arguments erstellt. Könnte noch fehlerhaft sein.
  if (res$status_code==400) stop ("Please check the URL of the item you want to add.")
  if (res$status_code==403) stop ("A valid consumer key for Pocket must be provided.")
  if (res$status_code==401) stop ("A valid request token for Pocket must be provided.")
  if (res$status_code==200) message ("You added an item to your pocket list.")
  #if (res$status_code==200) message( paste("You added", res$request$fields$url, "to your pocket list."))
  
}
 
 

#Test
pocket_add(consumer.key=consumer_key, access.token=access_token, add.url="https://correlaid.org/")
pocket_add(consumer.key=consumer_key, access.token=access_token, add.url="url existiert nicht")
pocket_add(consumer.key="12345", access.token=access_token, add.url="https://correlaid.org/")
pocket_add(consumer.key=consumer_key, access.token="12345", add.url="https://correlaid.org/")


### Sachen, die man evtl. noch hinzufügen könnte
# Error: your consumer key must have the add permission (Problem: woran erkennt man eine fehlende add permission?)
# Add mit title, tags,...



