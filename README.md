# surprisinglytidy

<!-- badges: start -->
<!-- badges: end -->

The goal of surprisinglytidy is to make `xaringan` presentations
a little easier and more flexible, including extending the functionality
of CSS with [Sass](https://sass-lang.com/).
It's still very much in development.

## Installation

`surprisinglytidy` is not yet available on [CRAN](https://CRAN.R-project.org).
You can install it with `devtools`:

```r
devtools::install_github("surprisinglytidy")
```

## Example

`knitr` has 5 options that can be really handy for fine-grained
control of `R` output:

* `class.source`
* `class.output`
* `class.message`
* `class.warning`
* `class.error`

Unfortunately, they have at least 2 drawbacks here.

First none of these work well with `xaringan`.
They set the class using [Pandoc](https://pandoc.org/) syntax:

    ```{class1 class2}
    text here
    ```

Second, `class.output` does not add classes to [plots](https://twitter.com/xieyihui/status/1136333313340256257?s=20).

If, instead of using the traditional `xaringan` template
(File --> New File --> R Markdown --> From Template --> Ninja Presentation),
you use the Tidy Presentation template from this package,
It will handle all those issues for you automatically.
There is sample code for adding classes.

## Next Steps

For now this is all very rudimentary.
The presentation template, for example, is merely a copy
of [Yihui Xie](https://yihui.name/)'s "Hello Ninja" presentation,
and the setup code in it is unpolished.

Furthermore, I haven't even gotten to adding Sass functionality,
which will be very exciting!
But one step at a time. For now the package is up on Github. :)

Please let me know if you have any questions or requests,
either for further development or for stronger documentation.

Best,
Benjamin Wolfe
