#' Upgrade all installed packages
#'
#' @param job If `TRUE`, run the upgrade in a background RStudio job
#' @param daily If `TRUE`, exit early if `upgrade()` has already been run today
#'
#' @return Invisibly returns `NULL`
#' @export

upgrade <- function(job = rlang::is_installed("job"), daily = FALSE) {
  date <- as.character(Sys.Date())
  cache <- fs::path(rappdirs::user_cache_dir("arhfn"), "pkg_updates.txt")

  if (fs::file_exists(cache)) {
    if (daily) {
      cache_date <- readLines(cache)
      if (identical(date, cache_date)) return(invisible(NULL))
    }
  } else {
    fs::dir_create(fs::path_dir(cache))
    fs::file_create(cache)
  }

  upgrade_impl <- function(date, cache) {
    packages <- pak::pkg_list()
    packages <- dplyr::coalesce(packages$remotepkgref, packages$package)
    packages <- stringr::str_subset(packages, "local::", negate = TRUE)

    cli::cli_h1("Upgrading packages")

    if (!pingr::is_online()) stop("Internet connection is unavailable.")

    pak::pkg_install(packages, ask = FALSE)

    writeLines(date, cache)
  }

  if (isTRUE(job)) {
    rlang::check_installed("job")

    return(
      job::empty(
        {
          upgrade_impl(date, cache)
          job::export(NULL)
        },
        import = c(upgrade_impl, date, cache),
        opts = c(options("pkgType"), options("repos")),
        title = "Update packages"
      )
    )
  }

  upgrade_impl(date, cache)
}
