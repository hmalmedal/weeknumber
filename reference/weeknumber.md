# Helper for weeknumber vectors

`weeknumber()` is a user-facing helper that casts `x` to double and then
constructs a `weeknumber` vector with
[`new_weeknumber()`](https://hmalmedal.github.io/weeknumber/reference/new_weeknumber.md).

## Usage

``` r
weeknumber(x = double())
```

## Arguments

- x:

  An object coercible to double.

## Value

A `weeknumber` vector.

## Details

This helper follows the vctrs convention of coercing user input before
calling the low-level constructor. For ISO year/week pairs, strings, or
date-time objects, use
[`make_weeknumber()`](https://hmalmedal.github.io/weeknumber/reference/make_weeknumber.md)
or
[`as_weeknumber()`](https://hmalmedal.github.io/weeknumber/reference/as_weeknumber.md).

## Examples

``` r
weeknumber(0:2)
#> <weeknumber[3]>
#> [1] 2000-W01 2000-W02 2000-W03
```
