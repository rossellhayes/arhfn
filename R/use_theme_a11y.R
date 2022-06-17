#' Apply a color-blind friendly RStudio theme
#'
#' @param dark A logical indicating whether to use a dark theme.
#'   If `NULL`, the default, the decision is based on whether the current active
#'   theme is a light theme or a dark theme.
#' @inheritParams rsthemes::use_theme_dark
#'
#' @export
use_theme_a11y <- function(dark = NULL, quietly = FALSE) {
  if (is.null(dark) && rstudioapi::isAvailable()) {
    dark <- rstudioapi::getThemeInfo()$dark
  }

  style <- if (isTRUE(dark)) "dark" else "light"

  theme <- paste0("a11y-", style, " {rsthemes}")
  apply_theme <- utils::getFromNamespace("apply_theme", "rsthemes")
  apply_theme(theme, quietly, style)
}
