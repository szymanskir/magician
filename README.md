
<!-- README.md is generated from README.Rmd. Please edit that file -->

# magician

<!-- badges: start -->

[![R-CMD-check](https://github.com/szymanskir/magician/workflows/R-CMD-check/badge.svg)](https://github.com/szymanskir/magician/actions)
<!-- badges: end -->

> **Important:** The package is a work in progress that for now only
> supports spinning up disposable Postgres containers.

Magicians make things appear and dissapear, the `magician` package
creates disposable containers in your tests. The package has been
inspired by [withr](https://withr.r-lib.org/) and
[testcontainers](https://www.testcontainers.org/).

The main motivation behind the package is testing whether the
interactions between your R code and databases work correctly. There
already exist a couple of approaches to testing those interactions:

1.  Mocking your database interactions - an approach implemented in the
    [dittodb](https://dittodb.jonkeane.com/) package, this allows you to
    test whether your code handling the results of a database
    interaction is working correctly. It does not check the correctness
    of your query.
2.  Running your queries against an [SQLite](https://www.sqlite.org/)
    database, for example using the
    [withr::with\_db\_connection](https://withr.r-lib.org/reference/with_db_connection.html).
    However, if you use a different database in production and your
    queries use database specific functions (for example `ILIKE` or
    `hstore` in Postgres), you might not be able to test those against
    an SQLite instance.

`magician` allows you to spin up a database in a docker container for
testing purposes. This allows you test complex queries which make use of
database specific functions. The aim of the package is to extend the
aforementioned tooling. While it provides you with greater confidence
that your query will work on your production database (as you can test
your queries agains the same database engine that you use in production)
it comes at a cost of your test suite’s speed as now your tests need to
spin up a docker container.

To see an example of using `magician` in your test suite run in GitHub
Actions, check out [this example
repository](https://github.com/szymanskir/magician-tests-example).

## Installation

You can install the development version of magician from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("szymanskir/magician")
```

## Examples

### Postgres

``` r
with_postgres_connection("postgres:12.10", {
 DBI::dbGetQuery(con, "select version();")
})
```

> The `with_postgres_connection` attaches a `con` object that stores the
> Postgres connection you can use in your code expression
