#' Add a package dependency
#'
#' @param package Unquoted or quoted name of package.
#' @param type Whether to add the package as `"Imports"`, `"Depends"`,
#'   or `"Suggests"` (case insensitive).
#' @param min_version Optionally, supply a minimum version for the package.
#'   If `TRUE`, uses the currently installed version.
#'   If `FALSE` or `NULL`, no minimum is set.
#'   Defaults to `NULL` for `use_package()` and `use_suggests()` and
#'   `TRUE` for `use_depends()`.
#' @param tidy Whether to run [usethis::use_tidy_description()] after adding
#'   dependency. Defaults to `TRUE`.
#'
#' @return Adds `package` to file `DESCRIPTION`
#' @export

use_package <- function(..., type = "Imports", min_version = NULL, tidy = TRUE) {
  use_package_impl(
    rlang::enexprs(...), type = type, min_version = min_version, tidy = tidy
  )
}

#' @rdname use_package
#' @export

use_depends <- function(..., min_version = TRUE, tidy = TRUE) {
  use_package_impl(
    rlang::enexprs(...),
    type = "Depends",
    min_version = min_version,
    tidy = tidy
  )
}

#' @rdname use_package
#' @export

use_suggests <- function(..., min_version = NULL, tidy = TRUE) {
  use_package_impl(
    rlang::enexprs(...),
    type = "Suggests",
    min_version = min_version,
    tidy = tidy
  )
}

use_package_impl <- function(
    packages, type = "Imports", min_version = NULL, tidy = TRUE
) {
  type <- stringr::str_to_title(type)

  if (isFALSE(min_version)) min_version <- NULL

  lapply(packages, function(package) {
    if (rlang::is_symbol(package)) package <- rlang::expr_text(package)
    usethis::use_package(package, type = type, min_version = min_version)
  })

  if (isTRUE(tidy)) {
    usethis::use_tidy_description()
  }

  invisible(NULL)
}
