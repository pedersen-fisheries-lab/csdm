#' Bayesian catch saturation-depletion model
#'
#' Catch saturation-depletion model.
#'
#' @param x To change
#' @param y To change
#' @param ... To change
#'
#' @return
#' An object of class `stanfit` returned by `rstan::sampling`.
#'
#' @export
csdm <- function(x, y, ...) {

  standata <- list(x = x, y = y, N = length(y))

  out <- rstan::sampling(stanmodels$nonlinear_cpue_grouped,
                         data = standata, ...)

  return(out)
}
