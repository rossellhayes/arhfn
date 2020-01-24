## Load functions
suppressMessages(
  invisible(lapply(list.files("R", full.names = TRUE), source))
)

drake_config(plan, parallelism = "future", jobs = 7, lock_envir = FALSE)
