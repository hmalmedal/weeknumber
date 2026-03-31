# Make weeknumber from ISO year and week

Construct a `weeknumber` vector from ISO 8601 year and week values.

## Usage

``` r
make_weeknumber(year = 2000, week = 1)
```

## Arguments

- year:

  Year, coerced to numeric.

- week:

  ISO week, coerced to numeric.

## Value

A `weeknumber` vector.

## Details

Input arguments are recycled to their common size, using
[`vctrs::vec_recycle_common()`](https://vctrs.r-lib.org/reference/vec_recycle.html).
Weeks outside the valid range for the corresponding year result in `NA`.

## Examples

``` r
make_weeknumber(2000:2001, 4:5)
#> <weeknumber[2]>
#> [1] 2000-W04 2001-W05
make_weeknumber(2019:2020, 53)
#> <weeknumber[2]>
#> [1] <NA>     2020-W53
```
