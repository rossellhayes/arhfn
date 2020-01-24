## library() calls go here
if (!require("pacman")) {install.packages("pacman"); library(pacman)}

p_load(
  drake,
  future
)

p_load_gh()

plan(multiprocess)
