% Generated by roxygen2 (4.0.2): do not edit by hand
\name{rnb.plot.betadistribution.probeCategories}
\alias{rnb.plot.betadistribution.probeCategories}
\title{rnb.plot.betadistribution.probeCategories}
\usage{
rnb.plot.betadistribution.probeCategories(beta.matrix, probe.cat,
  annotation = "Group", color.legend = NULL, log.str = NULL,
  points.per.group = rnb.getOption("distribution.subsample"))
}
\arguments{
\item{beta.matrix}{Beta values in the form of a non-empty \code{matrix} of type \code{double}. Rows in this matrix
must correspond to Infinium probes, and columns - to samples.}

\item{probe.cat}{\code{factor} vector of length \code{nrow(beta.matrix)} corresponding to the
probe categories.}

\item{annotation}{Name of the annotation being visualized, in the form of a \code{character} vector of length 1.}

\item{color.legend}{Color legend to use in the form of a \code{character} vector with element names. The values in
this vector should encode colors. All values in \code{probe.cat} must be present in the names of
this color legend. If this parameter is \code{NULL}, a default color legend is be constructed.}

\item{log.str}{string specifying more details for the log file}

\item{points.per.group}{the targeted number of points per group. Set this to a value < 1 to disable subsampling. More
information in the Details section of \code{\link{rnb.step.betadistribution}}}
}
\value{
The plot as a \code{ggplot2} object.
}
\description{
plot beta value distrubions given probe categories
}
\examples{
\dontrun{
library(RnBeads.hg19)
data(small.example.object)
logger.start(fname=NA)
meth.mat <- meth(rnb.set.example)
probe.types <- annotation(rnb.set.example)[, "Design"]
rnb.plot.betadistribution.probeCategories(meth.mat,probe.types,annotation="Infinium probe type")
}
}
\author{
Fabian Mueller
}
\seealso{
rnb.plot.betadistribution.sampleGroups
}

