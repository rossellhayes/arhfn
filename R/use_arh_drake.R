##' Setup a drake project
##'
##' Creates files and directories according to the arh_drake template.
##'
##' @title use_arh_drake
##' @return Nothing. Modifies your workspace.
##' @export

use_arh_drake <- function() {
  usethis::use_directory("R")
  usethis::use_directory("data")
  usethis::use_directory("output")
  usethis::use_template("_drake.R", package = "arhfn")
  usethis::use_template("makefile.R", package = "arhfn")
  usethis::use_template("packages.R", save_as = "R/packages.R", package = "arhfn")
  usethis::use_template("plan.R", save_as = "R/plan.R", package = "arhfn")
}
