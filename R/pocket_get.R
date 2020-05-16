#' pocket_get2
#' @description Get a data frame with your pocket data.
#' @param favorite boolean. Default NULL. Allows to filter for favorited items. If TRUE, only favorited items will be returned. If FALSE, only un-favorited items will be returned.
#' @param item_type character. Default NULL. Allows to filter for content type of items. Valid values are: "image", "article", "video". Please note that there might be Pocket items that do not belong to any of those types. The Pocket API documentation only mentions those three.
#' @param tag character. Default NULL. Only one tag can be filtered at a time. Set to '_untagged_' if you only want to get untagged items.
#' @param state character. Default "all". Allows to filter on unread/archived items or return all. Valid values are "unread", "archive", "all".
#' @param consumer_key character. Your Pocket consumer key. Defaults to Sys.getenv("POCKET_CONSUMER_KEY").
#' @param access_token character. Your Pocket request token. Defaults to Sys.getenv("POCKET_ACCESS_TOKEN").
#' @return tibble. Tibble with one row for each Pocket item.
#' @details See https://getpocket.com/developer/docs/v3/retrieve for the meaning of certain variable values.
#' @importFrom purrr map_dfr
#' @export
pocket_get <- function(favorite = NULL,
                       item_type = NULL,
                       tag = NULL,
                       state = "all",
                       consumer_key = Sys.getenv("POCKET_CONSUMER_KEY"),
                       access_token = Sys.getenv("POCKET_ACCESS_TOKEN")) {
  if (consumer_key == "") stop(error_message_consumer_key())
  if (access_token == "") stop(error_message_access_token())

  # arguments to call the post function with later
  # we do this so that we can add additional arguments to ... conditional on the if statements
  post_fun_args <- list(
    endpoint = "get",
    consumer_key = consumer_key,
    access_token = access_token,
    detailType = "complete", # all variables
    state = state
  )

  if (!is.null(favorite)) {
    if (!is.logical(favorite) || length(favorite) != 1) stop("The favorite argument can only be TRUE or FALSE.")
    post_fun_args$favorite <- as.integer(favorite)
  }

  if (!is.null(item_type)) {
    if (!item_type %in% c("image", "video", "article")) stop("The item_type argument can only be one of the following:  'image', 'article', 'video'.")
    post_fun_args$contentType <- item_type
  }

  if (!is.null(tag)) {
    if (!is.character(tag) || length(tag) != 1) stop("The tag argument can only be a character string.")
    post_fun_args$tag <- tag
  }


  if (!is.null(state)) {
    if (!is.character(state) || length(state) != 1) stop("The state argument can only be one of the following: 'unread', 'archive', 'all'")
    if(!(state %in% c("unread", "archive", "all"))) stop("The state argument can only be one of the following: 'unread', 'archive', 'all'")
    post_fun_args$state <- state
  }

  res <- do.call(pocket_post_, args = post_fun_args)
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
    resolved_title = item$resolved_title,
    favorite = char_to_bool_(item$favorite),
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
