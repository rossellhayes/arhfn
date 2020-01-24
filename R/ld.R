##' Load drake targets and source all files in R/
##'
##' @export

ld <- function() {
  message("Loading targets")
  drake::loadd(envir = .GlobalEnv)
  message("Loading functions")
  src()
}
