#' Add a package dependency
#'
#' @param package Unquoted or quoted name of package.
#' @param type Whether to add the package as an import, dependency,
#'   or suggestion (case insensitive).
#' @param min_version Optionally, supply a minimum version for the package.
#'   If `TRUE`, uses the currently installed version.
#'   If `FALSE` or `NULL`, no minimum is set.
#'   Defaults to `NULL` for `use_package()` and `TRUE` for `use_dependency()`.
#' @param tidy Whether to run [usethis::use_tidy_description()] after adding
#'   dependency. Defaults to `TRUE`.
#' @param character_only A logical indicating whether `package` can be assumed
#'   to be a character string.
#'
#' @return Adds `package` to file `DESCRIPTION`
#' @export

use_package <- function(
  package, type = c("Imports", "Depends", "Suggests"),
  min_version = NULL, tidy = TRUE, character_only = FALSE
) {
  if (!character_only) {
    package <-
      rlang::as_label(rlang::sym(rlang::as_name(rlang::enquo(package))))
  }

  if (isTRUE(min_version == FALSE)) {min_version <- NULL}

  type <- stringr::str_to_title(type)

  usethis::use_package(
    package,
    type        = match.arg(tools::toTitleCase(type)),
    min_version = min_version
  )

  if (tidy) {usethis::use_tidy_description()}
}

#' @rdname use_package
#' @export

use_depends <- function(
  package, min_version = TRUE, tidy = TRUE, character_only = FALSE
) {
  if (!character_only) {
    package <-
      rlang::as_label(rlang::sym(rlang::as_name(rlang::enquo(package))))
  }

  use_package(
    package, type = "Depends", min_version = min_version, tidy = tidy,
    character_only = TRUE
  )
}

#' @rdname use_package
#' @export

use_suggests <- function(
  package, min_version = TRUE, tidy = TRUE, character_only = FALSE
) {
  if (!character_only) {
    package <-
      rlang::as_label(rlang::sym(rlang::as_name(rlang::enquo(package))))
  }

  use_package(
    package, type = "Suggests", min_version = min_version, tidy = tidy,
    character_only = TRUE
  )
}
