# AGENTS.md

Guidance for coding agents working in this repository.

## Repository Summary

- This is an R package named `weeknumber`.
- The package implements a `vctrs`-based `weeknumber` class with
  helpers, formatting, arithmetic, casting, and `ggplot2` scale support.
- Package metadata lives in `DESCRIPTION`; exported objects are
  registered in `NAMESPACE`.

## Repository Layout

- `R/`: package source files.
- `man/`: generated Rd documentation.
- `tests/testthat/`: unit tests.
- `tests/testthat.R`: testthat entrypoint.
- `README.Rmd`: source for the README.
- `README.md`: generated from `README.Rmd`; do not edit by hand.
- `.github/workflows/`: CI definitions for `R-CMD-check` and `pkgdown`.

## Working Norms

- Make focused changes and preserve existing package structure and
  naming.
- Prefer editing the relevant file in `R/` and adding or updating tests
  in `tests/testthat/` for behavior changes.
- Keep function style consistent with the existing codebase: small
  functions, explicit namespace qualification where already used, and
  straightforward base R/vectorized logic.
- Do not hand-edit generated outputs unless the user explicitly asks for
  it.

## Generated Files

- `README.md` is generated from `README.Rmd`.
- `man/*.Rd` and likely parts of `NAMESPACE` are generated from roxygen
  comments in `R/`.
- If you change public functions, documentation, or exports, update
  roxygen comments in `R/` first and regenerate docs with
  `roxygen2::roxygenise()` if the environment supports it.

## Suggested Workflow

1.  Read the relevant file(s) in `R/` and related tests in
    `tests/testthat/`.
2.  Implement the change in the smallest sensible scope.
3.  Add or update tests when behavior changes.
4.  Regenerate documentation only when needed.
5.  Run targeted verification first, then broader checks if warranted.

## Verification Commands

Run from the repository root.

``` r
testthat::test_dir("tests/testthat")
```

``` r
devtools::test()
```

``` sh
R CMD check --no-manual .
```

CI also installs dependencies with
`remotes::install_deps(dependencies = TRUE)` and runs
`rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "error")`.

## Notes For Documentation Changes

- Keep examples aligned with package behavior.
- If README examples change, update `README.Rmd` and regenerate
  `README.md`.
- If exported APIs change, ensure `NAMESPACE` and `man/` stay in sync
  with roxygen.

## Notes For Dependency Changes

- Declare runtime dependencies in `Imports` and test-only or optional
  tooling in `Suggests`.
- Prefer minimal dependency changes because CI and installation rely on
  standard R package tooling.
