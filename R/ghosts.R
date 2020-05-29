#' Print ghosts in the console
#'
#' @return
#' @export

ghosts <- function() {
  n <- min(floor((getOption("width", "80")) / 12), 6)

  colors <- c(
    "\033[31m", "\033[32m", "\033[33m", "\033[34m", "\033[35m", "\033[36m"
  )

  lines <- list(
    "    OOO     ",
    "   OOOOO    ",
    "    O OO  O ",
    " O OOOOOOO  ",
    "  OOOOOOO   ",
    "    OOOOOO  ",
    "     OOOOO  ",
    "       OOOO ",
    "           O"
  )

  lines <- lapply(lines, rep, n)
  lines <- lapply(lines, function(x) paste0(colors[seq_len(n)], x))
  lines <- lapply(lines, paste, collapse = "")
  lines <- paste(unlist(lines), collapse = "\n")
  lines <- paste0("\n", lines, "\033[39m\n\n")

  cat(gsub("O", cli::symbol$full_block, lines))

  invisible("ghosts")
}


