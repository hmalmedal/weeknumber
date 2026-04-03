# Low-level constructor for weeknumber vectors

This is a low-level constructor that creates `weeknumber` vectors from
their underlying double representation.

## Usage

``` r
new_weeknumber(x = double())
```

## Arguments

- x:

  A double vector of ISO week offsets from `2000-W01`.

## Value

A `weeknumber` vector.

## Details

The underlying double values count ISO weeks relative to `2000-W01`, so
`0` represents `2000-W01`, `1` represents `2000-W02`, and so on.
Non-finite values are converted to `NA_real_`.

This constructor follows the vctrs convention of validating only the
underlying storage type. Use
[`weeknumber()`](https://hmalmedal.github.io/weeknumber/reference/weeknumber.md)
for a user-facing helper and
[`is_weeknumber()`](https://hmalmedal.github.io/weeknumber/reference/is_weeknumber.md)
to test for the class.

## Examples

``` r
new_weeknumber(c(0, 1, NA_real_))
#> <weeknumber[3]>
#> [1] 2000-W01 2000-W02 <NA>    
```
