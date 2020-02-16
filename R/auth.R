
#' get_consumer_key
#' @description add entry to pocket
#' @param consumer_key character string. Your Pocket consumer key. See https://getpocket.com/developer/docs/authentication.
#' @param access_token character string. Your Pocket request token. See https://getpocket.com/developer/docs/authentication.
#' @param add_url character string. The URL of the item you want to add to your Pocket list.
#' @export
#'
#'
#'
get_request_token <- function(consumer_key) {
  # see https://www.jamesfmackenzie.com/getting-started-with-the-pocket-developer-api/
  REQUEST_URL <- "https://getpocket.com/v3/oauth/request"
  redirect_uri <- "https://google.com"

  # get request token
  res <- httr::POST(REQUEST_URL, body = list(consumer_key = consumer_key, redirect_uri = redirect_uri))
  httr::stop_for_status(res)

  request_token <- httr::content(res)$code
  return(request_token)
}

create_authorize_url <- function(request_token) {
  # create url to give the app access
  AUTHORIZE_URL <- "https://getpocket.com/auth/authorize"
  redirect_uri <- "https://google.com"

  auth_url <- httr::parse_url(AUTHORIZE_URL)
  auth_url$query <- list(code = request_token, redirect_uri = redirect_uri)
  auth_url <- build_url(auth_url)

  message("Enter this URL into your browser and grant your app access:")
  return(auth_url)
}

get_access_token <- function(consumer_key, request_token) {
  AUTHORIZE_URL_V3 <- "https://getpocket.com/v3/oauth/authorize"

  authorize_url <- parse_url(AUTHORIZE_URL_V3)
  authorize_url$query <- list(consumer_key = consumer_key, code = request_token)
  authorize_url <- build_url(authorize_url)
  print(authorize_url)

  authorize_url <- httr::parse_url(AUTHORIZE_URL_V3)
  res <- httr::POST(authorize_url, body = list(consumer_key = consumer_key, code = request_token))

  httr::stop_for_status(res)
  access_token <- httr::content(res)$access_token
  return(access_token)
}

consumer_key = "89891-b2243a15cee1fc03947e224b"
req_token <- get_request_token(consumer_key)
create_authorize_url(req_token)
acc_token <- get_access_token(consumer_key, req_token)









consumer_key <- Sys.getenv("POCKET_CONSUMER_KEY")
consumer_key
REQUEST_URL <- "https://getpocket.com/v3/oauth/request"
AUTH_URL <- "https://getpocket.com/v3/oauth/authorize"

request_token_url <- httr::parse_url(REQUEST_URL)
res <- httr::POST(request_token_url, body = list(consumer_key = consumer_key, redirect_uri = "https://google.com"))
request_token <- httr::content(res)$code

# create url and enter in browser
paste0("https://getpocket.com/auth/authorize?request_token=", request_token, "&redirect_uri=https://www.google.com")
# -> enter this URL in browser and authorize the app

authorize_url <- httr::parse_url(AUTH_URL)
res <- httr::POST(authorize_url, body = list(consumer_key = consumer_key, code = request_token))
res
httr::content(res)
access_token <- httr::content(res)$access_token
access_token

get_url <- httr::parse_url("https://getpocket.com/v3/get")
res <- httr::POST(get_url, body = list(consumer_key = consumer_key, access_token = access_token))
httr::content(res)



