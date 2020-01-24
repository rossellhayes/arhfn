##' Source all files in R/ directory
##'
##' @export

src <- function() {
  invisible(lapply(list.files("R", full.names = TRUE), source))
}
