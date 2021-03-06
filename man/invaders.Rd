% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/invaders.R
\name{invaders}
\alias{invaders}
\title{Print Space Invaders in the console}
\usage{
invaders()
}
\value{
Invisibly returns the string "invaders"
}
\description{
To run on startup, add the following to your \verb{~/.Rprofile}
(see \code{\link[usethis:edit]{usethis::edit_r_profile()}}):\preformatted{if (interactive() && requireNamespace("arhfn", quietly = TRUE)) \{
  setHook("rstudio.sessionInit", function(isNewSession) \{
     arhfn::invaders()
  \}, action = "append")
\}
}
}
\examples{
invaders()
}
\seealso{
\code{\link[=random_art]{random_art()}} to print random color art
}
