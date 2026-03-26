# Coerce to week number class

Coerce object to week number class.

## Usage

``` r
as_weeknumber(x)
```

## Arguments

- x:

  An object.

## Examples

``` r
as_weeknumber(c(-1:1, 51:52, NA))
#> <weeknumber[6]>
#> [1] 1999-W52 2000-W01 2000-W02 2000-W52 2001-W01 <NA>    
as_weeknumber("2000-W01")
#> <weeknumber[1]>
#> [1] 2000-W01
as_weeknumber(as.Date("2000-12-28"))
#> <weeknumber[1]>
#> [1] 2000-W52
```
