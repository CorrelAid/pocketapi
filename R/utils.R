#' pocket_post_
#' @description internal function to make a POST requests to a Pocket API endpoint.
#' @param endpoint character. endpoint to make a request to.
#' @param consumer_key character. Pocket consumer key.
#' @param access_token character. Pocket access token.
#' @param ... additional named arguments to be put into the body of the POST request.
#' @keywords internal
pocket_post_ <- function(endpoint, consumer_key, access_token, ...) {
  BASE_URL <- "https://getpocket.com/v3/"
  res <- httr::POST(
    glue::glue(BASE_URL, endpoint),
    body = list(
      consumer.key = consumer_key,
      access.token = access_token,
      ...
    )
  )
  return(res)
}

#' @importFrom httr status_code
#' @importFrom glue glue
pocket_stop_for_status_ <- function(res) {
  if (httr::status_code(res) >= 300) {

    status <- res$headers$status
    x_error <- res$headers$`x-error`

    if (is.null(status)) {
      status <- httr::status_code(res)
    }
    stop(glue::glue("Error during API request:
                    {status}: {x_error}"))
  }
}

error_message_consumer_key <- function() {
  return("POCKET_CONSUMER_KEY does not exist as environment variable. Add it to your R environment or manually specify the consumer_key argument.")
}

error_message_access_token <- function() {
  return("POCKET_ACCESS_TOKEN does not exist as environment variable. Add it to your R environment or manually specify the consumer_key argument.")
}
