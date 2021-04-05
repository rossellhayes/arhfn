#' Run makefile
#'
#' Sources the contents of '_make.R' in an RStudio job
#'
#' @return Invisilbe [`NULL`]
#' @export

make <- function() {
  rstudioapi::documentSave()
  if (file.exists("_make.R")) {
    rstudioapi::jobRunScript("_make.R")
  } else {
    abort_msg(paste("File", path("_make.R"), "not found."))
  }
  invisible(NULL)
}
