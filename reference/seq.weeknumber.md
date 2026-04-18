# Generate Sequences of Week Numbers

Generate regular sequences of `weeknumber` values.

## Usage

``` r
# S3 method for class 'weeknumber'
seq(from, to, by, length.out = NULL, along.with = NULL, ...)
```

## Arguments

- from:

  A length-1 `weeknumber` vector giving the start of the sequence.

- to:

  A length-1 `weeknumber` vector giving the end of the sequence.

- by:

  A length-1 numeric week increment.

- length.out:

  Desired length of the output sequence.

- along.with:

  Take the length from this object.

- ...:

  Unused.

## Value

A `weeknumber` vector.

## Details

This method mirrors classed [`seq()`](https://rdrr.io/r/base/seq.html)
methods such as [`seq.Date()`](https://rdrr.io/r/base/seq.Date.html).
Supply `from` and `to`, or one endpoint together with
`length.out`/`along.with`. When `by` is supplied, it should be a single
numeric week increment.

## Examples

``` r
seq(make_weeknumber(2000, 1), make_weeknumber(2000, 9), by = 2)
#> <weeknumber[5]>
#> [1] 2000-W01 2000-W03 2000-W05 2000-W07 2000-W09
seq(from = make_weeknumber(2000, 1), length.out = 3, by = 1)
#> <weeknumber[3]>
#> [1] 2000-W01 2000-W02 2000-W03
```
