#' Print Space Invaders in the console
#'
#' To run on startup, add the following to your `~/.Rprofile`
#' (see [usethis::edit_r_profile()]):
#' ```
#' if (interactive() && requireNamespace("arhfn", quietly = TRUE)) {
#'   setHook("rstudio.sessionInit", function(isNewSession) {
#'      arhfn::invaders()
#'   }, action = "append")
#' }
#' ```
#'
#' @return Invisibly returns the string "invaders"
#' @seealso [random_art()] to print random color art
#' @export
#'
#' @examples invaders()

invaders <- function() {
  n <- min(floor(getOption("width", "60") / 12), 6)

  colors <- paste0("\033[", 36:31, "m")[sample(1:6, 6)]
  colors <- lapply(as.list(rep(colors, ceiling(n / 6))), rep, 4)

  invaders <- list(
    list(
      "   ▀▄   ▄▀  ",
      "  ▄█▀███▀█▄ ",
      " █▀███████▀█",
      " ▀ ▀▄▄ ▄▄▀ ▀"
    ),
    list(
      " ▄ ▀▄   ▄▀ ▄",
      " █▄█▀███▀█▄█",
      " ▀█████████▀",
      "  ▄▀     ▀▄ "
    ),
    list(
      "   ▄██▄  ",
      " ▄█▀██▀█▄",
      " ▀█▀██▀█▀",
      " ▀▄    ▄▀"
    ),
    list(
      "   ▄██▄  ",
      " ▄█▀██▀█▄",
      " ▀▀█▀▀█▀▀",
      " ▄▀▄▀▀▄▀▄"
    ),
    list(
      "  ▄▄▄████▄▄▄ ",
      " ███▀▀██▀▀███",
      " ▀▀███▀▀███▀▀",
      "  ▀█▄ ▀▀ ▄█▀ "
    ),
    list(
      "  ▄▄▄████▄▄▄ ",
      " ███▀▀██▀▀███",
      " ▀▀▀██▀▀██▀▀▀",
      " ▄▄▀▀ ▀▀ ▀▀▄▄"
    )
  )

  lines <- lapply(
    invaders,
    stringr::str_replace_all,
    c("\u2580" = "\\\\u2580", "\u2584" = "\\\\u2584", "\u2588" = "\\\\u2588")
  )

  invalid <- TRUE
  while (invalid) {
    first   <- lapply(list(1:2, 3:4, 5:6), sample, 1)
    second  <- setdiff(1:6, first)
    indices <- c(sample(first, 3), sample(second, 3), recursive = TRUE)
    invalid <- all(indices[3:4] %in% 1:2) ||
      all(indices[3:4] %in% 3:4) ||
      all(indices[3:4] %in% 5:6)
  }

  lines <- rep(lines[indices], ceiling(n / 6))
  lines <- mapply(paste0, colors[seq_len(n)], lines[seq_len(n)])
  lines <- apply(lines, 1, paste, collapse = "")
  lines <- paste(unlist(lines), collapse = "\n")
  lines <- paste0(lines, "\033[39m\n\n")
  lines <- stringi::stri_unescape_unicode(lines)

  cat(lines)

  invisible("invaders")
}
