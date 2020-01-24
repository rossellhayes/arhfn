library(drake)
r_make()

if (interactive()) {
  # To load objects
  loadd()

  # To load functions
  invisible(lapply(list.files("R", full.names = TRUE), source))
}
