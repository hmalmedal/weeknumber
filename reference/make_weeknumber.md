# Make week number

Make week number object from year and week.

## Usage

``` r
make_weeknumber(year = 2000, week = 1)
```

## Arguments

- year:

  Year, coerced to numeric.

- week:

  Week, coerced to numeric.

## Details

Input arguments are recycled to their common size. Invalid weeks result
in `NA`.

## Examples

``` r
make_weeknumber(2000:2001, 4:5)
#> <weeknumber[2]>
#> [1] 2000-W04 2001-W05
make_weeknumber(2019:2020, 53)
#> <weeknumber[2]>
#> [1] <NA>     2020-W53
```
