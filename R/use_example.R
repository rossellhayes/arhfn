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

#' Create or edit a test file
#'
#' @param name Either a name without extension, or `NULL` to create a test file
#'   file based on currently open file in the script editor.
#' @param open Whether to open the file for interactive editing.
#'
#' @return If a test file does not already exist, creates a test file.
#'   If `open` is `TRUE`, opens the test file.
#' @seealso [usethis::use_test()], which this function is modified from
#'
#' @importFrom rlang %||%
#' @export

use_test <- function(name = NULL, open = rlang::is_interactive()) {
  if (!usethis:::uses_testthat()) {
    usethis::use_testthat()
  }
  name <- name %||% fs::path_file(rstudioapi::getSourceEditorContext()$path)
  name <- paste0("test-", name)
  name <- fs::path_ext_set(fs::path_ext_remove(name), "R")
  usethis:::check_file_name(name)
  path <- fs::path("tests", "testthat", name)
  if (!fs::file_exists(path)) {
    usethis::use_template("test-example-2.1.R", save_as = path, open = FALSE)
  }
  usethis::edit_file(usethis::proj_path(path), open = open)
}
