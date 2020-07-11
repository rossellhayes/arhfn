#' Add a package logo to README.Rmd
#'
#' @export

use_readme_logo <- function() {
  i <- '<img src="man/figures/logo.png?raw=TRUE" align="right" height="138" />'

  suppressMessages(usethis::edit_file("README.Rmd"))

  usethis::ui_todo(
    c(
      paste0(
        "Add the following code after the first heading in your ",
        usethis::ui_path("README.Rmd"), ":"
      ),
      usethis::ui_code(i)
    )
  )

  if (windows <- Sys.info()[["sysname"]] == "Windows") {
    writeClipboard(i)
    usethis::ui_info("Code copied to clipboard.")
  }
}
