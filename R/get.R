
#install.packages("httr")
#install.packages("jsonlite")

require("httr")
require("jsonlite")

#install.packages("usethis")
#usethis::edit_r_environ()
consumer_key <- Sys.getenv("POCKET_CONSUMER_KEY")
access_token <- Sys.getenv("POCKET_ACCESS_TOKEN")


url <- httr::parse_url("https://getpocket.com/v3/get")
url$query <- list(consumer_key = consumer_key, access_token = access_token)
res <- POST(url)
res
str(res)
