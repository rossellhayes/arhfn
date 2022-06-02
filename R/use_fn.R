#' Create or edit a .R file
#'
#' @param name Function name, either as a string or an unquoted name
#' @param ... Unquoted function arguments
#' @param folder The folder to place the file in. Defaults to "R".
#'
#' @seealso [usethis::use_r()]
#'
#' @export
#' @examples
#'
#' \dontrun{
#' use_fn(test_function, x, y = "z")
#' }

use_fn <- function(name, ..., folder = "R") {
  name <- rlang::as_label(rlang::sym(rlang::as_name(rlang::enquo(name))))

  args                     <- lapply(rlang::enquos(...), rlang::as_label)
  names                    <- names(args)
  names(args)[names != ""] <- paste0(names[names != ""], " = ")
  args                     <- paste(paste0(names(args), args), collapse = ", ")

  defn <- paste0(name, " <- function(", args, ") {\n  \n}")

  if (!dir.exists(folder)) dir.create(folder, recursive = TRUE)
  target_file <- file.path(folder, paste0(name, ".R"))
  if (file.exists(target_file)) {
    usethis::ui_info(
      paste("Function", usethis::ui_path(target_file), "already exists.")
    )
    usethis::edit_file(target_file)
    return(invisible(TRUE))
  }
  readr::write_file(x = defn, path = target_file)
  usethis::ui_done(paste("Function", usethis::ui_path(target_file), "created."))
  usethis::edit_file(target_file)
  invisible(TRUE)
}
