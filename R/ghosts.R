#' Print ghosts in the console
#'
#' To run on startup, add the following to your `~/.Rprofile`
#' (see [usethis::edit_r_profile()]):
#' ```
#' if (interactive() && requireNamespace("arhfn", quietly = TRUE)) {
#'   setHook("rstudio.sessionInit", function(isNewSession) {
#'     arhfn::ghosts()
#'   }, action = "append")
#' }
#' ```
#'
#' @return Invisibly returns the string "ghosts"
#' @seealso [random_art()] to print random color art
#' @export
#'
#' @examples ghosts()

ghosts <- function() {
  n <- min(floor(getOption("width", "60") / 12), 6)

  colors <- paste0("\033[", 36:31, "m")[sample(1:6, 6)]
  colors <- rep(colors, ceiling(n / 6))

  ghosts <- list(
    "    ▄▄▄     ",
    "   ▀█▀██  ▄ ",
    " ▀▄██████▀  ",
    "    ▀█████  ",
    "       ▀▀▀▀▄"
  )

  lines <- lapply(
    ghosts,
    stringr::str_replace_all,
    c("\u2580" = "\\\\u2580", "\u2584" = "\\\\u2584", "\u2588" = "\\\\u2588")
  )

  lines <- lapply(lines, rep, n)
  lines <- lapply(lines, function(x) paste0(colors[seq_len(n)], x))
  lines <- lapply(lines, paste, collapse = "")
  lines <- paste(unlist(lines), collapse = "\n")
  lines <- paste0(lines, "\033[39m\n\n")
  lines <- stringi::stri_unescape_unicode(lines)

  cat(lines)

  invisible("ghosts")
}


