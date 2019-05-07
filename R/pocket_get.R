#' pocket_get
#' @description get pocket data
#' @return dataframe.
#' @export
pocket_get <- function(){
  # this is a stub
  return(data.frame())
}


# CODE DUMP HERE

library(httr)
library(purrr)
library(tibble)

get_url <- httr::parse_url("https://getpocket.com/v3/get")
res <- httr::POST(get_url, body = list(consumer_key = Sys.getenv("POCKET_CONSUMER_KEY"), access_token = Sys.getenv("POCKET_ACCESS_TOKEN")))
httr::content(res)

# Extracting stuff
# Getting an overview

output <- httr::content(res)$list

df  <- output %>% {
  tibble(
    id = map_chr(., "item_id"),
    URL = map_chr(., "given_url"),
    title = map_chr(., "given_title"),
    wordcount = map_chr(., "word_count"),
    language = map_chr(., "lang")
  )
}

