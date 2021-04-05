#' Load all packages, functions, and targets
#'
#' @return Invisible [`NULL`]
#' @export

load_all <- function() {
  invisible(rstudioapi::executeCommand("activateConsole"))

  if (file.exists("DESCRIPTION")) {
    devtools::load_all()
  } else {
    cli::cli_process_start("Loading packages...")
    if (file.exists("_packages.R")) {
      source("_packages.R", local = .GlobalEnv)
    } else {
      invisible(
        lapply(
          unique(renv::dependencies()$Package),
          library,
          character.only = TRUE
        )
      )
    }
    cli::cli_process_done(NULL, "Loaded packages!")

    cli::cli_process_start("Loading functions...")
    lapply(
      list.files("R", full.names = TRUE, recursive = TRUE),
      source, local = .GlobalEnv
    )
    cli::cli_process_done(NULL, "Loaded functions!")
  }

  if (file.exists("_targets.R"))  {
    cli::cli_process_start("Loading targets...")
    targets::tar_load(
      names = tidyselect::everything(),
      meta  = dplyr::filter(targets::tar_meta(), type != "function"),
      envir = .GlobalEnv
    )
    cli::cli_process_done(NULL, "Loaded targets!")
  }

  cli::cli_alert_success("All done!")

  invisible(NULL)
}
