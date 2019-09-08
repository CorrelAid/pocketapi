#' pocket_get
#' @description Get a data frame with your pocket data.
#' @param consumer_key character string. Your Pocket consumer key. See https://getpocket.com/developer/docs/authentication.
#' @param access_token character string. Your Pocket request token. See https://getpocket.com/developer/docs/authentication.
#' @param add_item character vector. Specify a vector listing additional items to be retrieved from Pocket. Baseline: item ID, URL, and item title.
#' @param all_items logical. If set to TRUE, all possible items are returned. This is equivalent to manually defining all items in 'add_item'.
#' @param raw logical. If set to TRUE, pocket data is returned as part of a list that additionally contains all raw information and possible items.
#' @return dataframe or list.
#' @export
#'
pocket_get <- function(consumer_key,
           access_token,
           add_item = c(),
           all_items = FALSE,
           raw = FALSE) {


    if (missing(consumer_key))
      stop(
        "Argument 'consumer_key' is missing. A valid consumer key for Pocket must be provided. See 'https://getpocket.com/developer/docs/authentication' on how to obtain one."
      )
    if (missing(access_token))
      stop(
        "Argument 'access_token' is missing. A valid request token for Pocket must be provided. See 'https://getpocket.com/developer/docs/authentication' on how to obtain one."
      )

    get_url <- httr::parse_url("https://getpocket.com/v3/get")
    res <-
      httr::POST(get_url,
                 body = list(consumer_key = consumer_key, access_token = access_token))

    if(res$status_code==200){print("Your request was successful.")}
    if(res$status_code==400){print("Invalid request syntax, please contact the package maintainers.")}
    if(res$status_code==401){print("Authentication problem.")}
    if(res$status_code==403){print("Authentication successful, but access denied due to lack of permission or rate limiting.")}
    if(res$status_code==503){print("Pocket's sync server is down for scheduled maintenance. Try again later.")}

    output <- httr::content(res)$list
    output.categories <- unique(unlist(lapply(output, names)))

    # Generate data set from Pocket output
    if(all_items==FALSE){
      to.be.retrieved <- c(c("item_id", "given_url", "given_title"), add_item)
    }else{
      to.be.retrieved <- c(output.categories[-c(21:24)])
      to.be.retrieved <- c(output.categories)
    }

    data <- lapply(to.be.retrieved, function(item)
                      unlist(lapply(output, function(x)
                      x[[item]]))) # get the requested item data in list format

    # Retrieve one entry at a time to account for differing lengths (some entries have more items covered than others)
    mat <- sapply(data, '[', data[[1]][1])
    if(length(data[[1]]) > 1){
      for(i in 2:length(data[[1]])){
      id <- data[[1]][i]
      mat <- rbind(mat, sapply(data, '[', id) )
      }
    }

    df <- data.frame(mat)
    colnames(df) <- to.be.retrieved
    rownames(df) <- 1:nrow(df)

    # Flexibly assigning numeric & character classes to appropriate variables based on first row of output (default = factor for all, which seems undesirable), and
    # adjust (if-statements) for cases with one or none numeric/character variables
    df.temp <- apply(df, 2, as.character)
    temp <- grepl("^[[:digit:][:space:]]{1,}$", df.temp[1, ])
    if (length(temp[temp == FALSE]) > 1) {
      df[, !temp] <- apply(df.temp[, !temp], 2, as.character)
    } else{
      if (length(temp[temp == FALSE]) == 1) {
        df[, !temp] <- as.character(df.temp[, !temp])
      }
    }
    if (length(temp[temp == TRUE]) > 1) {
      df[, temp] <- apply(df.temp[, temp], 2, as.numeric)
    } else{
      if (length(temp[temp == TRUE]) == 1) {
        df[, temp] <- as.numeric(df.temp[, temp])
      }
    }

    if (raw == FALSE) {
      return(data.frame(df))
    } else{
      return(list(
        pocket.data = df,
        raw.output = output,
        items = output.categories
      ))
    }

  }
