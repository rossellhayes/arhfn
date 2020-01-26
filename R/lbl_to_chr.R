##' Convert labelled tibble columns to characters
##'
##' @param tbl Tibble to modify
##' @title lbl_to_chr
##' @return A tibble with all labelled columns replaced with character columns
##' @export

lbl_to_chr <- function(tbl) {
  dplyr::mutate_if(tbl, haven::is.labelled, ~ as.character(haven::as_factor(.)))
}
