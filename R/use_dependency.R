use_dependency <- function(package) {
  package <- rlang::as_label(rlang::sym(rlang::as_name(rlang::enquo(name))))

  usethis::use_package(package, type = "Depends", min_version = TRUE)
}
