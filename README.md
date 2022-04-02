
<!-- README.md is generated from README.Rmd. Please edit that file -->

# magician

<!-- badges: start -->

[![R-CMD-check](https://github.com/szymanskir/magician/workflows/R-CMD-check/badge.svg)](https://github.com/szymanskir/magician/actions)
<!-- badges: end -->

Magicians make things appear and dissapear, the `magician` package
creates disposable containers in your tests. The package has been
inspired by [withr](https://withr.r-lib.org/) and
[testcontainers](https://www.testcontainers.org/)

## Installation

You can install the development version of magician from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools") %>% 
devtools::install_github("szymanskir/magician")
```

## Examples

### Postgres

``` r
with_postgres_connection("postgres:12.10", {
 DBI::dbGetQuery(con, "select version();")
})
```

> The `with_postgres_connection` attaches a `con` object with the
> Postgres connection you can use
