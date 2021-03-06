#' Create or edit an example .R file
#'
#' Create or edit an example .R file
#'
#' @param name File name, without extension; will create if it doesn't already
#'     exist. If not specified, and you're currently in a .R file, will guess
#'     name based on .R name.
#'
#' @seealso [usethis::use_r()] and [usethis::use_test()]
#'
#' @importFrom rlang %||%
#' @export

use_example <- function(name = NULL) {
  name <- name %||% usethis:::get_active_r_file(path = "R")
  name <- usethis:::slug(name, "R")
  usethis:::check_file_name(name)
  usethis::use_directory("examples")
  usethis::use_build_ignore("examples")
  path      <- fs::path("examples", name)
  full_path <- usethis::proj_path(path)
  usethis::edit_file(full_path)
  usethis::ui_todo(
    paste(
      "Add",
      usethis::ui_code(paste("#' @example", path)),
      "to your roxygen documentation"
    )
  )
  invisible(full_path)
}
