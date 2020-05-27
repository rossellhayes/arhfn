#' README badge for MIT license
#'
#' @seealso [usethis::use_badge()]
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' use_mit_badge()
#' }

use_mit_badge <- function() {
  usethis::use_badge(
    badge_name = "License: MIT",
    href       = "https://opensource.org/licenses/MIT",
    src        = "https://img.shields.io/badge/license-MIT-blueviolet.svg"
  )
}
