#' Create or edit an example .R file
#'
#' Creates an R script in `man/examples` to store examples for a function.
#'
#' @param name Either a name without extension, or `NULL` to create the paired
#'   file based on currently open file in the script editor.
#'   If the `R/` or test file is open, `use_example()` will create/open the
#'   corresponding example file.
#' @param dir The directory where example scripts will be stored.
#'   Defaults to `man/examples`.
#' @inheritParams usethis::use_r
#'
#' @seealso [usethis::use_r()] and [usethis::use_test()]
#'
#' @export

use_example <- function(
  name = NULL, dir = "man/examples", open = rlang::is_interactive()
) {
  # Determine file name
  name <- name %||% fs::path_file(rstudioapi::getSourceEditorContext()$path)
  name <- gsub("^test-", "", name)
  name <- fs::path_ext_set(name, "R")

  # Determine path to `R/` file
  r_path <- fs::path("R", name)

  # Determine path to example file
  usethis::use_directory(dir)
  example_name <- paste0("example-", name)
  example_path <- fs::path(dir, example_name)

  if (fs::file_exists(r_path) && rlang::is_installed("roxygen2")) {
    # Check contents of roxygen tags in `R/` file
    roxygen_tags <- roxygen2::parse_file(r_path)
    roxygen_tags <- purrr::map(roxygen_tags, "tags")
    roxygen_tags <- purrr::flatten(roxygen_tags)

    # Check if `R/` file already has the path in its `@example` tag
    example_path_tags <- roxygen_tags[roxygen_tags$tag == "example"]
    example_path_tags <- purrr::map_chr(example_path_tags, "val")
    example_tag_already_present <- any(example_path_tags == example_path)

    # Check if `R/` file has examples in an `@examples` tag
    examples_tags <- roxygen_tags[roxygen_tags$tag == "examples"]
    preexisting_examples <- purrr::map_chr(examples_tags, "raw")
    preexisting_examples <- gsub("^\\n+", "", preexisting_examples)
  } else {
    # Defaults if `R/` file's roxygen tags cannot be read
    example_tag_already_present <- FALSE
    preexisting_examples <- character(0)
  }

  # Inform user to add `@example` tag with example path
  if (!example_tag_already_present) {
    if (length(preexisting_examples) > 0) {
      usethis::ui_todo(paste(
        "Replace", usethis::ui_code("@examples"),
        "in your roxygen documentation with the following line:"
      ))
    } else {
      usethis::ui_todo(
        "Add the following line to your roxygen documentation:"
      )
    }

    usethis::ui_line("#' @example {example_path}")
  }

  # If the example file doesn't already exist, copy examples from the `R/` file
  if (!fs::file_exists(example_path)) {
    writeLines(preexisting_examples, example_path)
  }

  usethis::edit_file(example_path, open = open)
  invisible(example_path)
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
