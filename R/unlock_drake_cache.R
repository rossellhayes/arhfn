##' Unlock drake cache
##'
##' @export

drake_unlock <- function() drake::drake_cache(".drake")$unlock()
