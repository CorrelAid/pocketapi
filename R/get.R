
#install.packages("httr")
#install.packages("jsonlite")

require("httr")
require("jsonlite")

#install.packages("usethis")
usethis::edit_r_environ()
consumer_key <- Sys.getenv("consumer_key")
access_token <- Sys.getenv("access_token")

get <- GET("https://getpocket.com/v3/oauth/request", authenticate(user_name, password, type = "basic"))

get <- GET("https://getpocket.com/v3/oauth/request", authenticate(consumer_key, password, type = "basic"))



