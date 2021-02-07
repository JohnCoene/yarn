
<!-- badges: start -->
![R-CMD-check](https://github.com/JohnCoene/yarn/workflows/R-CMD-check/badge.svg)
<!-- badges: end -->

# yarn

Interact with [yarn](https://yarnpkg.com/) from the R console.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("JohnCoene/yarn")
```

## Example

``` r
library(yarn)

# installs yarn itself globally
install_yarn()

yarn_init()

yarn_add("browserify", scope = "global")
```

See also [npm](https://github.com/JohnCoene/npm).
