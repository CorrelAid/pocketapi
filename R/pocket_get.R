#' pocket_get2
#' @description Get a data frame with your pocket data.
#' @param consumer_key character. Your Pocket consumer key. Defaults to Sys.getenv("POCKET_CONSUMER_KEY").
#' @param access_token character. Your Pocket request token. Defaults to Sys.getenv("POCKET_ACCESS_TOKEN").
#' @return tibble. Tibble with one row for each Pocket item.
#' @details See https://getpocket.com/developer/docs/v3/retrieve for the meaning of certain variable values.
#' @importFrom purrr map_dfr
#' @export
pocket_get <- function(
           consumer_key = Sys.getenv("POCKET_CONSUMER_KEY"),
           access_token = Sys.getenv("POCKET_ACCESS_TOKEN")) {
    if (consumer_key == "")
      stop(
        "POCKET_CONSUMER_KEY does not exist as environment variable. Add it to your R environment or manually specify the consumer_key argument."
      )
    if (access_token == "")
      stop(
        "POCKET_ACCESS_TOKEN does not exist as environment variable. Add it to your R environment or manually specify the access_token argument. See ?get_access_token for details."
      )
  res <- pocket_post_("get", consumer_key, access_token, detailType = "complete")
  pocket_stop_for_status_(res)

  pocket_content <- content(res)
  pocket_items <- pocket_content$l

  items_df <- purrr::map_dfr(pocket_items, parse_item_)
  return(items_df)
}

#' parse_item_
#' @description parse item in the response list into a mini tibble with one row.
#' @param item Pocket item from the Pocket entry list.
#' @return tibble.
#' @keywords internal
parse_item_ <- function(item) {
  item_df <- tibble::tibble(
    item_id = item$item_id,
    resolved_id = item$resolved_id,
    given_url = item$given_url,
    given_title = item$given_title,
    favorite = char_to_bool_(item$favorite) ,
    status = as.integer(item$status),
    excerpt = item$excerpt,
    is_article = char_to_bool_(item$is_article),
    has_image = as.integer(item$has_image),
    has_video = as.integer(item$has_video),
    word_count = as.integer(item$word_count),
    tags = ifelse(is.null(item$tags), NA, paste(item$tags %>% purrr::map_chr("tag"), collapse = ",")),
    authors = ifelse(is.null(item$authors), NA, item$authors),
    images = ifelse(is.null(item$images), NA, item$images),
    image = ifelse(is.null(item$images), NA, item$image)
  )

  item_df
}


char_to_bool_ <- function(char) {
  return(as.logical(as.integer(char)))
}
