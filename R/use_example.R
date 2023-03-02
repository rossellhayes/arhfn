# These functions are adapted from functions in the usethis package
# https://github.com/r-lib/usethis
#
# usethis is released under the MIT License
#
# Copyright (c) 2020 usethis authors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# 	The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
#' @return If an example file does not already exist, creates an example file.
#'   If `open` is `TRUE`, opens the example file.
#' @seealso [usethis::use_r()] and [usethis::use_test()]
#'
#' @importFrom rlang %||%
#' @export

use_example <- function(
  name = NULL, dir = "man/examples", open = rlang::is_interactive()
) {
  # Determine file name
  name <- fs::path(dir, compute_name(name))

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

  usethis::edit_file(usethis::proj_path(example_path), open = open)
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
    usethis:::use_testthat_impl()
  }

  path <- fs::path("tests", "testthat", paste0("test-", compute_name(name)))
  if (!fs::file_exists(path)) {
    usethis::use_template("test-example-2.1.R", save_as = path)
  }
  usethis::edit_file(usethis::proj_path(path), open = open)

  invisible(TRUE)
}

#' Create or edit an R file
#'
#' @param name Either a name without extension, or `NULL` to create a test file
#'   file based on currently open file in the script editor.
#' @param open Whether to open the file for interactive editing.
#'
#' @return If an R file does not already exist, creates an R file.
#'   If `open` is `TRUE`, opens the R file.
#' @seealso [usethis::use_r()], which this function is modified from
#'
#' @importFrom rlang %||%
#' @export

use_r <- function(name = NULL, open = rlang::is_interactive()) {
  usethis::use_directory("R")

  path <- fs::path("R", compute_name(name))
  usethis::edit_file(usethis::proj_path(path), open = open)

  invisible(TRUE)
}

compute_name <- function(name = NULL, ext = "R", error_call = caller_env()) {
  if (!is.null(name)) {
    usethis:::check_file_name(name, call = error_call)

    if (fs::path_ext(name) == "") {
      name <- fs::path_ext_set(name, ext)
    } else if (fs::path_ext(name) != "R") {
      cli::cli_abort(
        "{.arg name} must have extension {.str {ext}}, not {.str {path_ext(name)}}.",
        call = error_call
      )
    }
    return(as.character(name))
  }

  if (!usethis:::rstudio_available()) {
    cli::cli_abort(
      "{.arg name} is absent but must be specified.",
      call = error_call
    )
  }
  compute_active_name(
    path = rstudioapi::getSourceEditorContext()$path,
    ext = ext,
    error_call = error_call
  )
}

compute_active_name <- function(path, ext, error_call = caller_env()) {
  if (is.null(path)) {
    cli::cli_abort(
      c(
        "No file is open in RStudio.",
        i = "Please specify {.arg name}."
      ),
      call = error_call
    )
  }

  ## rstudioapi can return a path like '~/path/to/file' where '~' means
  ## R's notion of user's home directory
  path <- usethis:::proj_path_prep(fs::path_expand_r(path))

  dir <- fs::path_dir(usethis:::proj_rel_path(path))

  file <- fs::path_file(path)
  if (dir == "tests/testthat") {
    file <- gsub("^test[-_]", "", file)
  } else if (dir == "man/examples") {
    file <- gsub("^example[-_]", "", file)
  }

  as.character(fs::path_ext_set(file, ext))
}
