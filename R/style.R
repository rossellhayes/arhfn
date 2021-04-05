style <- function(x, quote, color) {
  if (!is.null(quote)) {x <- encodeString(x, quote = quote)}
  x <- do.call(color, list(x), envir = asNamespace("crayon"))
  x
}

code  <- function(x) {style(x, "`",  "silver")}
value <- function(x) {style(x, NULL, "blue")}
path  <- function(x) {style(x, "'",  "blue")}

abort_msg <- function(...) {
  rlang::abort(message = c(...))
}
