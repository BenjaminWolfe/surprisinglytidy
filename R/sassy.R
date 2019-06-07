get_file <- function (file = NULL,
                      path = NULL,
                      packages = c("rmarkdown", "xaringan", "surprisinglytidy"),
                      fullpath = NULL,
                      ignore_error = FALSE) {

  if (!is.null(file) & !is.null(fullpath)) {
    stop("Please specify either `file` or `fullpath`, but not both.")
  }

  if (!is.null(fullpath)) if (!file.exists(fullpath)) {
    stop(glue::glue("{fullpath} does not exist."))
  } else {
    return(fullpath)
  }

  valid_path <- any(sapply(packages, function(package) {
    system.file(path %||% "", package = package) != ""
  }))
  if (!is.null(path) & !valid_path) {
    stop(glue("`{path}` does not exist in any of the packages specified."))
  }

  for (package in packages) {
    result <- system.file(path %||% "", file, package = package)
    if (result != "") break
  }
  if (result == "" & !ignore_error) stop(glue::glue(
    "file not found. file: '{file %||% 'NULL'}' path: '{path %||% 'NULL'}' ",
    "packages: ['{paste(packages, collapse = \"', '\")}'], ",
    "fullpath: '{fullpath %||% 'NULL'}'"
  ))
  result
}

#' Add a dependency
#'
#' Adds a dependency (external reference) to an R Markdown document.
#'
#' Inspired by \href{https://www.jaredlander.com/2017/07/fullscreen-background-images-in-ioslides-presentations/}{this guy}.
#' Must specify \code{file} (for package system files) or \code{fullpath}.
#' \code{path} is optional, to specify a path for a package system file.
#'
#' @param name     See \code{htmltools::htmlDependency}.
#' @param version  See \code{htmltools::htmlDependency}.
#' @param file     Filename of script or stylesheet.
#' @param path     Path within the package.
#'                 Ignored if \code{fullpath} is specified.
#' @param packages A vector of package names to search for the file.
#'                 Ignored if \code{fullpath} is specified.
#' @param fullpath Full path (relative or absolute) of file (all but filename).
#' @param attach   If TRUE, attaches the dependency.
#'                 If FALSE, returns the htmlDependency object to be attached.
#'
#' @importFrom glue glue
#' @export
#'
#' @examples
#' \dontrun{
#' add_dependency(
#'   "testy-css",
#'   packageVersion("surprisinglytidy"),
#'   file = "testy.css",
#'   path = "rmd/h/css"
#' )
#' add_dependency(
#'   "foo",
#'   "0.0.1",
#'   fullpath = "./bar.js" # same folder as .Rmd file
#' )
#' }
add_dependency <- function(name,
                           version,
                           file = NULL,
                           path = NULL,
                           packages = c(
                             "rmarkdown",
                             "xaringan",
                             "surprisinglytidy"
                           ),
                           fullpath = NULL,
                           attach = TRUE
) {
  fullpath <- get_file(file, path, packages, fullpath)

  dep <- switch(
    utils::tail(strsplit(file, "[.]")[[1]], 1),
    "js" = htmltools::htmlDependency(
      name    = name,
      version = version,
      src     = dirname(fullpath),
      script  = basename(fullpath)
    ),
    "css" = htmltools::htmlDependency(
      name        = name,
      version     = version,
      src         = dirname(fullpath),
      stylesheet  = basename(fullpath)
    )
  )
  if (attach) {
    htmltools::attachDependencies(htmltools::tags$span(""), dep, append = TRUE)
  } else {
    return(dep)
  }
}
