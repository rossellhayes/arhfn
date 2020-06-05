#' Print ghosts in the console
#'
#' To run on startup, add the following to your `~/.Rprofile`
#' (see [usethis::edit_r_profile()]):
#' ```
#' if (interactive() && requireNamespace("arhfn", quietly = TRUE)) {
#'   setHook("rstudio.sessionInit", function(isNewSession) {
#'     rsthemes::use_theme_auto(dark_start = "18:00", dark_end = "6:00")
#'   }, action = "append")
#' }
#' ```
#'
#' @return Invisibly returns the string "ghosts"
#' @export
#'
#' @examples ghosts()

ghosts <- function() {
  n <- floor(getOption("width", "60") / 12)

  colors <- rep(
    c("\033[36m", "\033[35m", "\033[34m", "\033[33m", "\033[32m", "\033[31m"),
    ceiling(n / 6)
  )

  # lines <- list(
  #   "    ▄▄▄     ",
  #   "   ▀█▀██  ▄ ",
  #   " ▀▄██████▀  ",
  #   "    ▀█████  ",
  #   "       ▀▀▀▀▄"
  # )

  lines <- list(
    "    lll     ",
    "   uwuww  l ",
    " ulwwwwwwu  ",
    "    uwwwww  ",
    "       uuuul"
  )

  lines <- lapply(lines, rep, n)
  lines <- lapply(lines, function(x) paste0(colors[seq_len(n)], x))
  lines <- lapply(lines, paste, collapse = "")
  lines <- paste(unlist(lines), collapse = "\n")
  lines <- paste0(lines, "\033[39m\n\n")
  lines <- gsub("u", "\u2580", lines)
  lines <- gsub("l", "\u2584", lines)
  lines <- gsub("w", "\u2588", lines)

  cat(lines)

  invisible("ghosts")
}


