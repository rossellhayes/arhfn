#' Increment package version using CalVer
#'
#' A complement to `usethis::use_version()` that uses
#' [Calendar Versioning](https://calver.org/).
#'
#' @param which If `which` is `"dev"`, `.9000` is appended to the end of the
#'   version number
#'
#' @return Updates the version number in the `DESCRIPTION` and `NEWS` file.
#' @seealso [usethis::use_version()]
#' @export

use_calendar_version <- function(which = NULL) {
  mockery::stub(
    usethis::use_version,
    "choose_version",
    function(message, which = NULL) {
      if (identical(which, "dev")) {
        date <- format(Sys.Date(), "%Y.%m.%d.9000")
        names(date) <- "dev"
      } else {
        date <- format(Sys.Date(), "%Y.%m.%d")
        names(date) <- "patch"
      }

      date
    }
  )

  usethis::use_version(which)
}

#' @rdname use_calendar_version
#' @export

use_calver <- use_calendar_version
