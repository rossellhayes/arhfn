#' Open or create a DESCRIPTION file
#'
#' If a `DESCRIPTION` file already exists, opens it.
#' If not, creates a `DESCRIPTION` file with [usethis::use_description()]
#'
#' @param ... Additional arguments passed to [usethis::use_description()]
#'
#' @export

use_description <- function(...) {
  description <- usethis::proj_path("DESCRIPTION")

  if (fs::file_exists(description)) {
    usethis::edit_file(description)
  } else {
    usethis::use_description(...)
  }
}
