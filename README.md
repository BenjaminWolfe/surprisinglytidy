# surprisinglytidy

<!-- badges: start -->
<!-- badges: end -->

The goal of surprisinglytidy is to make [`xaringan`][9] presentations
a little easier to tweak and more flexible, including extending the functionality
of CSS with [Sass][1].
It's still very much in development.

## Installation

`surprisinglytidy` is not yet available on [CRAN][2].
You can install it with `devtools`:

```r
devtools::install_github("BenjaminWolfe/surprisinglytidy")
```

## Example

`knitr` has 5 options to add classes to `R` output:

* `class.source`
* `class.output`
* `class.message`
* `class.warning`
* `class.error`

These can make for some [really beautiful output][8]
when wielded with nuance and finesse.

Unfortunately, they have at least 2 drawbacks for [`xaringan`][9] slides.

First [none of these work well with `xaringan`][3].
They set the class using [Pandoc][4] syntax,
which is not recognized by [remark.js][5]:

    ```{class1 class2}
    text here
    ```

Second, `class.output` does not add classes to [plots][6].

If, instead of using the traditional [`xaringan`][9] [Hello Ninja][10] template
(File --> New File --> R Markdown --> From Template --> Ninja Presentation),
you use the Tidy Presentation template from this package,
It will handle all those issues for you automatically.
There is sample code for adding classes.

## Next Steps

For now this is all very rudimentary.
The presentation template, for example, is merely a copy
of [Yihui Xie][7]'s "Hello Ninja" presentation,
and the setup code in it is unpolished.

Furthermore, I haven't even gotten to adding Sass functionality,
which will be very exciting!
But one step at a time. For now the package is up on Github. :)

Please let me know if you have any questions or requests,
either for further development or for stronger documentation.

Best,
Benjamin Wolfe

[1]: https://sass-lang.com/ "Sass"
[2]: https://CRAN.R-project.org "CRAN"
[3]: https://github.com/yihui/xaringan/issues/169 "classes in xaringan"
[4]: https://pandoc.org/ "Pandoc"
[5]: https://github.com/gnab/remark/wiki "remark.js"
[6]: https://twitter.com/xieyihui/status/1136333313340256257?s=20 "no plots"
[7]: https://yihui.name/ "Yihui Xie"
[8]: https://www.garrickadenbuie.com/blog/knitr-custom-class-output/ "classes"
[9]: https://github.com/yihui/xaringan "xaringan"
[10]: https://slides.yihui.name/xaringan/#1 "Hello Ninja"
