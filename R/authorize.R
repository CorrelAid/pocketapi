# Authorizing Pocket App

# install.packages("httr")
# install.packages("usethis")

library(httr)
library(usethis)

usethis::edit_r_environ()

consumer_key <- Sys.getenv("POCKET_CONSUMER_KEY")
consumer_key
REQUEST_URL <- "https://getpocket.com/v3/oauth/request"
AUTH_URL <- "https://getpocket.com/v3/oauth/authorize"

request_token_url <- httr::parse_url(REQUEST_URL)
res <- httr::POST(request_token_url, body = list(consumer_key = consumer_key, redirect_uri = "https://google.com"))
request_token <- httr::content(res)$code

paste0("https://getpocket.com/auth/authorize?request_token=", request_token, "&redirect_uri=https://www.google.com")

authorize_url <- httr::parse_url(AUTH_URL)
res <- httr::POST(authorize_url, body = list(consumer_key = consumer_key, code = request_token))
res
httr::content(res)
access_token <- httr::content(res)$access_token
access_token

get_url <- httr::parse_url("https://getpocket.com/v3/get")
res <- httr::POST(get_url, body = list(consumer_key = consumer_key, access_token = access_token))
httr::content(res)
