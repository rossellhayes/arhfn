##' Read rda file
##'
##' Imports an rda file *à la* the imports functions in **readr** and **haven**
##'
##' @param file RData file to read in
##' @title read_rda
##' @return A tibble comtained in the Rdata file
##' @export

read_rda <- function(file){
  load(file)
  dplyr::as_tibble(get(ls()[ls() != "file"]))
}
