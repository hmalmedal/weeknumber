# Get year and week number

Get year and week number from an object.

## Usage

``` r
year_week(x)
```

## Arguments

- x:

  An object.

## Value

A named list with two elements: `year` and `week`.

## Examples

``` r
x <- as_weeknumber(c(-1:1, 51:52, NA))
year_week(x)
#> $year
#> [1] 1999 2000 2000 2000 2001   NA
#> 
#> $week
#> [1] 52  1  2 52  1 NA
#> 
```
