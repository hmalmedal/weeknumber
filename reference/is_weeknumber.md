# Test for weeknumber vectors

`is_weeknumber()` tests whether `x` inherits from the `weeknumber`
class.

## Usage

``` r
is_weeknumber(x)
```

## Arguments

- x:

  An object to test.

## Value

`TRUE` if `x` is a `weeknumber` vector, otherwise `FALSE`.

## Examples

``` r
x <- weeknumber(10)
is_weeknumber(x)
#> [1] TRUE
is_weeknumber(10)
#> [1] FALSE
```
