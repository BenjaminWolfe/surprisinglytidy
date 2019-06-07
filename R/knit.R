# For the following regex helpers used below, see `data-raw/knit-helpers.R`:
# * comment_marker
# * comment_pattern
# * before_root
# * stuff_in_tag
# * class_pattern
# * quotation_mark

# when using glue() with regular expressions, {{}} helps disambiguate syntax
gum <- function(.x, ...) {
  glue::glue(.x, ..., .envir = parent.frame(), .open = "{{", .close = "}}")
}

# returns a vector of comments
get_comments <- function(html) {
  stringr::str_match_all(html, comment_pattern)[[1]][, 1]
}

strip_comments <- function(html) {
  stringr::str_replace_all(html, comment_pattern, comment_marker)
}

replace_comments <- function(html, comments, pattern = comment_marker) {
  Reduce(
    f = function(start_string, x) {
      stringr::str_replace(start_string, pattern, x)
    },
    x = comments,
    init = html
  )
}

# does the root node already have a `class` attribute?
check_for_classlist <- function(html) {
  stringr::str_detect(
    html,
    gum("{{before_root}}<{{stuff_in_tag}}{{class_pattern}}{{stuff_in_tag}}>")
  )
}

#' Add a class to the root node of an HTML string
#'
#' @param html Character. An HTML string.
#' @param class_name Character. Class name to be added to the root node.
#'
#' @return Character. An HTML string with the class name added to the root node.
#' @export
#'
#' @examples
#' library(magrittr)
#'
#' html <- "<!-- function handles comments--><div><p>R is fun</div></p>"
#' html %>% add_class("second-class")
#' html %>% add_class(".ok-to-start-with-period")
#' html %>% add_class("you-can") %>% add_class("chain-function-calls-too")
#' html %>% add_class("or add five at once")
#'
#' html <- "<div class='using-single-quotes'><p>R is fun</div></p>"
#' html %>% add_class("is-ok-too")
#'
#' html <- "<div class = 'lots-of-spaces'><p>R is fun</div></p>"
#' html %>% add_class("is-also-ok")
add_class <- function(html, class_name) {
  comments <- get_comments(html)
  class_name <- stringr::str_replace_all(class_name, "\\.", "")
  html %>%
    strip_comments() %>% {
      if (check_for_classlist(.)) {
        stringr::str_replace(
          .,
          gum(
            "({{before_root}})",
            "<",
            "({{stuff_in_tag}})",
            "({{class_pattern}})",
            "({{quotation_mark}})(.*?)\\4",
            "({{stuff_in_tag}})",
            ">"
          ),
          gum("\\1<\\2\\3\\4\\5 {{class_name}}\\4\\6>")
        )
      } else {
        stringr::str_replace(
          .,
          gum("({{before_root}})<({{stuff_in_tag}})>"),
          gum("\\1<\\2 class=\"{{class_name}}\">")
        )
      }
    } %>%
    replace_comments(comments)
}

#' Render chunk output with classes in Xaringan (for remark.js)
#'
#' Reasonably savvy in selecting the right option for your output.
#'
#' Currently the function uses \code{\link{render_html_chunk}}
#' if the \code{knitr} output is an \code{htmlwidget} or \code{knitr_kable}.
#' Otherwise, if \code{results} is set to "asis",
#' it uses \code{\link{render_asis_chunk}}.
#' For standard fenced output (beginning and ending with three backticks),
#' \code{surprisinglytidy} relies on \code{sassy.js}
#' to post-process Pandoc-syntax classes into remark.js classes.
#'
#' @param x Character. Chunk output.
#' @param options List. Options as passed from \code{knitr}.
#' @param inline Logical. As passed from \code{knitr}. Is the result inline?
#' @param ... Other parameters passed from \code{knitr}.
#'
#' @return \code{knitr} object for printing.
#' @export
#'
#' @examples
#' \dontrun{
#' # In \code{knitr} setup:
#' knitr::opts_chunk$set(         # first option tells knitr to use function
#'   render        = surprisinglytidy::render_chunk
#'   class.source  = ".r-source", # you can set each separately
#'   class.warning = ".r-warning",# class.output is what render_chunk will use
#'   class.message = ".r-message",# note that you can use multiple classes,
#'   class.error   = ".r-error",  # separated by a space
#'   class.output  = ".r-output .another-class"
#' )
#' }
render_chunk <- function(x, options, inline = FALSE, ...) {
  UseMethod("render_chunk")
}

#' @export
render_chunk.htmlwidget <- function(x, options, inline = FALSE, ...) {
  render_html_chunk(x, options = options, inline = inline, ...)
}

#' @export
render_chunk.knitr_kable <- function(x, options, inline = FALSE, ...) {
  render_html_chunk(x, options = options, inline = inline, ...)
}

#' @export
render_chunk.default <- function(x, options, inline = FALSE, ...) {
  if (options$results == "asis") {
    return(render_asis_chunk(x, options= options, inline = inline, ...))
  }
  knitr::knit_print(x, options = options, inline = inline, ...)
}

#' Render an HTML chunk with classes
#'
#' Called automatically by \code{\link{render_chunk}}.
#'
#' Currently called when printing an \code{htmlwidget} or \code{knitr_kable}.
#' Function is provided here for fine-grained control as needed.
#'
#' @param x Character. Chunk output.
#' @param options List. Options as passed from \code{knitr}.
#' @param inline Logical. As passed from \code{knitr}. Is the result inline?
#' @param ... Other parameters passed from \code{knitr}.
#'
#' @return \code{knitr} object for printing.
#' @export
#'
#' @examples
#' \dontrun{
#' # In knitr chunk options:
#' ```{r render=surprisinglytidy::render_html_chunk}
#' # some code here
#' ```
#' }
render_html_chunk <- function(x, options, inline = FALSE, ...) {
  chunk <- knitr::knit_print(x, options = options, inline = inline, ...)
  if (!length(options$class.output)) return(chunk)

  chunk[1] <- chunk[1] %>% add_class(options$class.output)
  chunk
}

#' Render an HTML chunk with classes
#'
#' Called automatically by \code{\link{render_chunk}}.
#'
#' Currently called only when \code{results} is set to "asis",
#' and even then \code{render_html_chunk} is used to print a \code{knitr_kable}.
#' Function is provided here for fine-grained control as needed.
#'
#' @param x Character. Chunk output.
#' @param options List. Options as passed from \code{knitr}.
#' @param inline Logical. As passed from \code{knitr}. Is the result inline?
#' @param ... Other parameters passed from \code{knitr}.
#'
#' @return \code{knitr} object for printing.
#' @export
#'
#' @examples
#' \dontrun{
#' # In knitr chunk options:
#' ```{r render=surprisinglytidy::render_asis_chunk}
#' # some code here
#' ```
#' }
render_asis_chunk <- function(x, options, inline = FALSE, ...) {
  chunk <- knitr::knit_print(x, options = options, inline = inline, ...)
  if (!length(options$class.output)) return(chunk)

  class_list <- stringr::str_split("hello world", pattern = " ")[[1]]
  chunk[1] <- paste0(".", class_list, "[") %>%
    paste(collapse = "") %>%
    paste(., chunk[1], strrep("]", length(class_list)), sep = "\n")
  chunk
}

#' Prepend class name to image extension
#'
#' Add the class name before the extension of \code{knitr} images
#'
#' When \code{class.output} is set, this function can add that class
#' before the file extension. From there, \code{pre-process.js} picks it up
#' by regex and adds the class to the plot.
#'
#' \code{set_extension} handles multiple classes separated by spaces.
#' Periods are stripped out and spaces are replaced with \code{sep}.
#' The full filename looks like this:
#' \code{(filepath)/(filename).(prefix)(classes)(suffix).(extension)}
#'
#' \code{pre-process.js} watches for this pattern, but \code{set_extension}
#' offers parameters to override them.
#'
#' @param options List. Options as passed by \code{knitr}.
#' @param prefix Character. See \code{details}.
#' @param suffix Character. See \code{details}.
#' @param sep Character. See \code{details}.
#'
#' @return Options to be passed back to \code{knitr}.
#' @export
#'
#' @examples
#' \dontrun{
#' knitr::opts_hooks$set(
#'   class.output = surprisinglytidy::set_extension,
#'   dev = surprisinglytidy::set_extension
#' )
#' }
set_extension <- function(options, prefix = ".", suffix = ".", sep = ".") {
  auto_ext <- knitr:::auto_exts[options$dev]
  if (!length(options$class.output)) {
    options$fig.ext = auto_ext
  } else {
    options$fig.ext <- options$class.output %>%
      stringr::str_replace_all("\\.", "") %>%
      stringr::str_split(" ") %>%
      purrr::pluck(1) %>%
      paste0(collapse = sep) %>%
      paste0(prefix, ., suffix, ".", auto_ext)
  }
  options
}
