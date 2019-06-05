#' pocket_get
#' @description Get a data frame with your pocket data.
#' @param consumer.key character string. Your Pocket consumer key. See https://getpocket.com/developer/docs/authentication.
#' @param access.token character string. Your Pocket request token. See https://getpocket.com/developer/docs/authentication.
#' @param add.item character vector. Specify a vector listing additional items to be retrieved from Pocket. Baseline: item ID, URL, and item title.
#' @param raw logical. If set to TRUE, pocket data is returned as part of a list that additionally contains all raw information and possible items.
#' @return dataframe or list.
#' @export
pocket_get <- function(consumer.key=NULL, access.token=NULL, add.item=c(), raw=FALSE){

if ( is.null(consumer.key) ) stop("Argument 'consumer_key' is missing. A valid consumer key for Pocket must be provided. See 'https://getpocket.com/developer/docs/authentication' on how to obtain one.")
if ( is.null(access.token) ) stop("Argument 'access_token' is missing. A valid request token for Pocket must be provided. See 'https://getpocket.com/developer/docs/authentication' on how to obtain one.")

library(httr)

get_url <- httr::parse_url("https://getpocket.com/v3/get")
res <- httr::POST(get_url, body = list(consumer_key = consumer.key, access_token = access.token))
output <- httr::content(res)$list
output.categories <- unique(unlist(lapply(output, names)))

# Generate data set from Pocket output
to.be.retrieved <- c(c("item_id", "given_url", "given_title"), add.item)
df <- data.frame(lapply(to.be.retrieved, function(item) unlist(lapply(output, function(x) x[[item]]))))
colnames(df) <- to.be.retrieved; rownames(df) <- 1:nrow(df)

# Flexibly assigning numeric & character classes to appropriate variables based on first row of output (default = factor for all, which seems undesirable), and
# adjust (if-statements) for cases with one or none numeric/character variables
df.temp <- apply(df, 2, as.character)
temp <- grepl("^[[:digit:][:space:]]{1,}$", df.temp[1,])
if(length(temp[temp==FALSE]) > 1){df[,!temp] <- apply(df.temp[,!temp], 2, as.character)
}else{
  if(length(temp[temp==FALSE]) == 1){df[,!temp] <- as.character(df.temp[,!temp])}
}
if(length(temp[temp==TRUE]) > 1){df[,temp] <- apply(df.temp[,temp], 2, as.numeric)
}else{
  if(length(temp[temp==TRUE]) == 1){df[,temp] <- as.numeric(df.temp[,temp])}
  }



if(raw==FALSE){
  return(data.frame(df)) }else{
  return( list(pocket.data=df, raw.output=output, items=output.categories) )
}

}



#### Testing the function ####

key <- Sys.getenv("POCKET_CONSUMER_KEY")
token <- Sys.getenv("POCKET_ACCESS_TOKEN")

pocket_get()
pocket_get(key)
pocket_get(key, token)
pocket_get(key, token, add.item = c("word_count", "lang", "time_to_read", "time_added"))
pocket_get(key, token, raw=TRUE)

test <- pocket_get(key, token)
test$item_id


