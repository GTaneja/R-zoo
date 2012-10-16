\name{ggplot2.zoo}
\alias{autoplot.zoo}
\alias{fortify.zoo}
\alias{ggplot2.zoo}

\title{Convenience Functions for Plotting zoo Objects with ggplot2}

\details{
  Convenience interface for visualizing zoo objects with ggplo2.
  \code{autoplot.zoo} uses \code{fortify.zoo} (with \code{melt = TRUE})
  to convert the zoo object into a data frame and then uses a suitable
  \code{aes()} mapping to visiualize the series.
}

\usage{
  \method{autoplot}{zoo}(object, geom = "line", facets, \dots)
  \method{fortify}{zoo}(model, data, melt = FALSE, \dots)
}

\arguments{
  \item{object}{an object of class \code{"zoo"}.}
  \item{geom}{character specifying which \code{geom} to use
    in \code{\link[ggplot2]{qplot}}.}
  \item{facets}{specification of \code{facets} for \code{\link[ggplot2]{qplot}}. The
    default is to use \code{facets = NULL} for univariate series and
    \code{facets = Series ~ .} for multivariate series.}
  \item{\dots}{further arguments passed to \code{\link[ggplot2]{qplot}}
    for \code{autplot} (and not used for \code{fortify}).}
  \item{model}{an object of class \code{"zoo"} to be converted to
    a \code{"data.frame"}.}
  \item{data}{not used (required by generic \code{\link[ggplot2]{fortify}}
    method).}
  \item{melt}{Should the resulting data frame be in long format (\code{melt = TRUE})
    or wide format (\code{melt = FALSE}).}
}

\description{
  \code{fortify.zoo} takes a zoo object and converts it into a data frame
  (intended for ggplot2). \code{autoplot.zoo} takes a zoo object and returns a
  ggplot2 object. It essentially uses the mapping \code{aes(x = Time, y = Value, group = Series)}
  and adds \code{colour = Series}, \code{linetype = Series}, \code{shape = Series}
  in the case of a multivariate series with \code{facets = NULL}.
}

\value{
  \code{fortify.zoo} returns a \code{data.frame} either in long format
  (\code{melt = TRUE}) or in wide format (\code{melt = FALSE}). The
  long format has three columns: the time \code{Index}, a
  factor indicating the \code{Series}, and the corresponding \code{Value}.
  The wide format simply has the time \code{Index} plus all columns
  of \code{coredata(model)}.
  
  \code{autoplot.zoo} returns a \code{ggplot} object.
}

\author{
  Trevor L. Davis \email{trevor.l.davis@gmail.com}, Achim Zeileis
}

\seealso{
  \code{\link[ggplot2]{autoplot}}, \code{\link[ggplot2]{fortify}}, \code{\link[ggplot2]{qplot}}
}

\examples{
if(require("ggplot2")) {
## example data
x.Date <- as.Date(paste(2003, 02, c(1, 3, 7, 9, 14), sep = "-"))
x <- zoo(rnorm(5), x.Date)
xlow <- x - runif(5)
xhigh <- x + runif(5)
z <- cbind(x, xlow, xhigh)

## univariate plotting
autoplot(x)
## by hand
ggplot(aes(x = Index, y = Value), data = fortify(x, melt = TRUE)) + geom_line() + xlab("Index") + ylab("x")
## adding series one at a time
last_plot() + geom_line(aes(x = Index, y = xlow), colour = "red", data = fortify(xlow))
## add ribbon for high/low band
ggplot(aes(x = Index, y = x, ymin = xlow, ymax = xhigh), data = fortify(x)) + geom_ribbon(fill = "darkgray") + geom_line()

## multivariate plotting in multiple or single panels
autoplot(z)                      ## multiple without color/linetype
autoplot(z, facets = Series ~ .) ## multiple with series-dependent color/linetype
autoplot(z, facets = NULL)       ## single with series-dependent color/linetype
## by hand with color/linetype and with/without facets
qplot(x = Index, y = Value, group = Series, colour = Series, linetype = Series, facets = Series ~ ., data = fortify(z, melt = TRUE)) +
  geom_line() + xlab("Index") + ylab("")
ggplot(aes(x = Index, y = Value, group = Series, colour = Series, linetype = Series), data = fortify(z, melt = TRUE)) +
  geom_line() + xlab("Index") + ylab("")
## variations
autoplot(z, geom = "point")
autoplot(z, facets = NULL) + geom_point()
autoplot(z, facets = NULL) + scale_colour_grey() + theme_bw()

## for "ts" series via coercion
autoplot(as.zoo(EuStockMarkets))
autoplot(as.zoo(EuStockMarkets), facets = NULL)
}
}