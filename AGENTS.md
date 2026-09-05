# AGENTS.md

## Package conventions

`weeknumber` is an R package implementing ISO 8601 weeks with a `vctrs`
class and ggplot2 position scales.

- Keep changes focused; add regression tests in `tests/testthat/` for
  behavior changes.
- Follow the existing small, vectorized functions. `vctrs` is imported
  package-wide in `R/weeknumber-package.R`; other packages generally use
  explicit `pkg::fun()` calls.
- Declare runtime dependencies in `DESCRIPTION` under `Imports`, and
  test-only or optional dependencies under `Suggests`. Avoid adding
  dependencies unnecessarily.

## Representation and edge cases

- `R/weeknumber-package.R` defines the constructors and calendar
  constants. Storage is a double vector of week offsets: `0` is
  `2000-W01`, whose Monday is `2000-01-03`. Non-finite constructor
  inputs become `NA_real_`.
- `R/make_weeknumber.R` and `R/year_week.R` convert between offsets and
  ISO year/week pairs using a 400-year cycle. Preserve ISO week-years at
  New Year; they can differ from calendar years. Invalid weeks,
  including week 53 in a 52-week year, become `NA`.
- When changing conversions or arithmetic, cover relevant year
  boundaries, 53-week years, offsets before the origin, missing values,
  empty vectors, and vctrs recycling/type behavior. Casting, type
  compatibility, and arithmetic methods live in `R/cast.R`, `R/ptype.R`,
  and `R/arith.R`.
- Scale behavior lives in `R/scales.R`, with tests in `test-scales.R`.
  Default breaks must remain whole visible weeks; `n.breaks` is a
  target, and explicit user breaks and labels must still work.

## Generated documentation

- Edit roxygen comments in `R/`, then run `roxygen2::roxygenise()` when
  changing documented APIs or S3 registrations. `man/*.Rd` and
  `NAMESPACE` are generated; inspect the diff for unrelated generator
  changes.
- Edit `README.Rmd`, then regenerate with
  `rmarkdown::render("README.Rmd")`. Ensure the examples use the updated
  package, for example by running
  [`pkgload::load_all()`](https://pkgload.r-lib.org/reference/load_all.html)
  in the same R session before rendering.
- Do not hand-edit generated outputs unless explicitly requested.

## Verification

Run from the repository root in R:

``` r

devtools::test(filter = "scales") # Replace with the relevant test filename stem.
devtools::test()                  # Full unit suite.
rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "error")
```

Use targeted tests first; run the full suite and package check for
broader package/API changes. For instructions-only edits, review the
diff instead. Avoid bare
[`testthat::test_dir()`](https://testthat.r-lib.org/reference/test_dir.html):
tests call unexported helpers and need the package loaded. If devtools
is unavailable, use
[`testthat::test_local()`](https://testthat.r-lib.org/reference/test_package.html).
CI configuration is in `.github/workflows/R-CMD-check.yaml`; it checks
Windows, macOS, and Linux with release R, plus Linux devel and oldrel-1.
