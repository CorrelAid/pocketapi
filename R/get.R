
#install.packages("httr")
#install.packages("jsonlite")

require("httr")
require("jsonlite")

#install.packages("usethis")
#usethis::edit_r_environ()
consumer_key <- Sys.getenv("consumer_key")
access_token <- Sys.getenv("access_token")

url <- httr::parse_url("https://getpocket.com/v3/get")
url$query <- list(consumer_key = consumer_key, access_token = access_token)
res <- httr::POST(url)
str(res)
httr::content(res)
res


# Looking at content
content <- httr::content(res)$list
str(content)

all.pocket.content <- unique(unlist(lapply(content, names)))
all.pocket.content

to.be.retrieved <- c("item_id", "given_url", "given_title", "resolved_title", "word_count", "lang")
df <- data.frame(lapply(to.be.retrieved, function(item) unlist(lapply(content, function(x) x[[item]]))))
colnames(df) <- to.be.retrieved; rownames(df) <- 1:nrow(df)




