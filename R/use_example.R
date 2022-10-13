#' Create or edit an example .R file
#'
#' Creates an R script in `man/examples` to store examples for a function.
#'
#' @param name File name, without extension.
#'   If [`NULL`], the default, automatically generate a name based on the file
#'   that is currently open.
#' @param dir The directory where example scripts will be stored.
#'   Defaults to `man/examples`.
#'
#' @seealso [usethis::use_r()] and [usethis::use_test()]
#'
#' @export

use_example <- function(name = NULL, dir = "man/examples") {
  rlang::check_installed("fs", "to use `use_example()`.")

  if (!is.null(name)) {
    name <- paste0(name, ".R")
  } else {
    rlang::check_installed(
      "rstudioapi",
      "to automatically detect the current file in `use_example()`."
    )

    current_path <- rstudioapi::getSourceEditorContext()$path
    current_dir <- fs::path_file(fs::path_dir(current_path))

    name <- fs::path_file(current_path)

    if (current_dir %in% c("tests", "testthat")) {
      name <- gsub("^test-", "", name)
    }

    name <- paste0("example-", name)
  }

  fs::dir_create(dir)

  path <- fs::path(dir, name)
  file.edit(path)

  cli::cli_inform(
    c("*" = "Add {.code #' @example {path}} to your roxygen documentation.")
  )
  invisible(path)
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
