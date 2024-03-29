% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/knit.R
\name{render_asis_chunk}
\alias{render_asis_chunk}
\title{Render an HTML chunk with classes}
\usage{
render_asis_chunk(x, options, inline = FALSE, ...)
}
\arguments{
\item{x}{Character. Chunk output.}

\item{options}{List. Options as passed from \code{knitr}.}

\item{inline}{Logical. As passed from \code{knitr}. Is the result inline?}

\item{...}{Other parameters passed from \code{knitr}.}
}
\value{
\code{knitr} object for printing.
}
\description{
Called automatically by \code{\link{render_chunk}}.
}
\details{
Currently called only when \code{results} is set to "asis",
and even then \code{render_html_chunk} is used to print a \code{knitr_kable}.
Function is provided here for fine-grained control as needed.
}
\examples{
\dontrun{
# In knitr chunk options:
```{r render=surprisinglytidy::render_asis_chunk}
# some code here
```
}
}
