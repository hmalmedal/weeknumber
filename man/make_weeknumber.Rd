% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_weeknumber.R
\name{make_weeknumber}
\alias{make_weeknumber}
\title{Make week number}
\usage{
make_weeknumber(year = 2000, week = 1)
}
\arguments{
\item{year}{Year, coerced to numeric.}

\item{week}{Week, coerced to numeric.}
}
\description{
Make week number object from year and week.
}
\details{
Input arguments are recycled to their common size. Invalid weeks result in
\code{NA}.
}
\examples{
make_weeknumber(2000:2001, 4:5)
make_weeknumber(2019:2020, 53)
}
