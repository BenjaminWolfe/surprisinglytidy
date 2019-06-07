# For easy regex processing in knit.R
# Unicode marker comes from https://en.wikipedia.org/wiki/Private_Use_Areas
comment_marker <- "\uF8FF"
comment_pattern <- "<!--.*?-->"
before_root <- "^[^<]*"
stuff_in_tag <- "[^>]*"
class_pattern <- "class\\s*=\\s*"
quotation_mark <- "[\'\"]"

usethis::use_data(
  comment_marker,
  comment_pattern,
  before_root,
  stuff_in_tag,
  class_pattern,
  quotation_mark,
  internal = TRUE,
  overwrite = TRUE
)
