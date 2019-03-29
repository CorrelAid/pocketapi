#' hello_world
#' @description hello_world prints a nice greeting to someone.
#' @param name character. Name of person / animal / ... to greet.
#' @return character. 'Hello World, ' followed by the name.
#' @export
hello_world <- function(name){
  return(paste0("Hello World, ", name))
}
