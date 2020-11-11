#' Copy path to latest file
#'
#' Copies the path to the newest file in a folder to the clipboard.
#'
#' @param path A character vector of one or more paths to find files in.
#' @param glob A wildcard aka globbing pattern (e.g. *.csv) passed on to
#'   [grep()] to filter paths.
#'
#' @return Returns a path as a character string and copies it to the clipboard.
#' @export

copy_last <- function(path = "~/Downloads", glob = NULL) {
  files <- fs::dir_info(path = path, glob = glob)

  file <- dplyr::slice_max(files, modification_time)
  file <- dplyr::pull(file, path)
  file <- encodeString(file, quote = '"')

  writeClipboard(file)

  file
}
