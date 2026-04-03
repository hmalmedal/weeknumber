# Extract ISO year and week components

Returns the ISO 8601 year and week for a `weeknumber` vector. For
convenience, character, factor, `Date`, `POSIXct`, and `POSIXlt` inputs
are first converted with
[`as_weeknumber()`](https://hmalmedal.github.io/weeknumber/reference/as_weeknumber.md).

## Usage

``` r
year_week(x)
```

## Arguments

- x:

  A `weeknumber` vector, or an object coercible with
  [`as_weeknumber()`](https://hmalmedal.github.io/weeknumber/reference/as_weeknumber.md).

## Value

A named list with components `year` and `week`, each the same length as
`x`. Missing inputs produce missing values in both components.

## Examples

``` r
x <- make_weeknumber(c(2019, 2020, NA), c(52, 53, NA))
year_week(x)
#> $year
#> [1] 2019 2020   NA
#> 
#> $week
#> [1] 52 53 NA
#> 

year_week(as.Date(c("2020-12-28", "2021-01-04")))
#> $year
#> [1] 2020 2021
#> 
#> $week
#> [1] 53  1
#> 
```
