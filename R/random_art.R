#' Print random color artwork in the console
#'
#' Randomly runs either [ghosts()] or [invaders()].
#'
#' To run on startup, add the following to your `~/.Rprofile`
#' (see [usethis::edit_r_profile()]):
#' ```
#' if (interactive() && requireNamespace("arhfn", quietly = TRUE)) {
#'   setHook("rstudio.sessionInit", function(isNewSession) {
#'     arhfn::random_art()
#'   }, action = "append")
#' }
#' ```
#'
#' @return Invisibly returns the function name of the artwork
#' @export
#'
#' @examples random_art()

random_art <- function() {
  fn <- list(arhfn::ghosts, arhfn::invaders)
  fn[[round(runif(1, 1, length(fn)))]]()
}
