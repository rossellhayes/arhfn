#' Add a package dependency
#'
#' @param package Unquoted or quoted name of package to add as dependency
#' @param min_version Optionally, supply a minimum version for the package.
#'   Defaults to `TRUE`, which uses the currently installed version.
#'   If `FALSE` or `NULL`, no minimum is set.
#' @param tidy Whether to run [usethis::use_tidy_description()] after adding
#'   dependency. Defaults to `TRUE`.
#'
#' @return Adds `package` to file `DESCRIPTION` as a dependency with the minimum
#'   version set to the currently installed version
#' @export

use_dependency <- function(package, min_version = TRUE, tidy = TRUE) {
  package <- rlang::as_label(rlang::sym(rlang::as_name(rlang::enquo(package))))

  if (min_version == FALSE) {min_version <- NULL}

  usethis::use_package(package, type = "Depends", min_version = min_version)

  if (tidy) {usethis::use_tidy_description()}
}
