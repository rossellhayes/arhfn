#' Edit shrtcts configuration file
#'
#' @return Path to the file, invisibly
#' @seealso [shrtcts::add_rstudio_shortcuts()]
#' @export

edit_shrtcts <- function() {
  path <- fs::path_home_r(".shrtcts.yaml")
  usethis::edit_file(path)
  usethis::ui_todo(
    paste(
      "Run", usethis::ui_code("add_rstudio_shortcuts()"),
      "for changes to take effect"
    )
  )
  invisible(path)
}
