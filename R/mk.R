##' Make drake targets in background
##'
##' @export

mk <- function() {
  rstudioapi::jobRunScript(
    here::here("makefile.r"),
    exportEnv = "R_GlobalEnv"
  )
  src()
}

##' Make drake targets in foreground
##'
##' @export

mk_fg <- function() {
  drake::r_make()
  message("\n", "Loading targets")
  drake::loadd(envir = .GlobalEnv)
  message("\n", "Loading functions")
  src()
  beepr::beep()
}
