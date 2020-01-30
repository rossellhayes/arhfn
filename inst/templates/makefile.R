library(drake)
r_make()

# To load objects
loadd()

if (interactive()) {
  # To load functions
  invisible(lapply(list.files("R", full.names = TRUE), source))
}
