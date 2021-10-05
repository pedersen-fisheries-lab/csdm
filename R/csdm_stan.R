#' Bayesian catch saturation-depletion model
#'
#' Catch saturation-depletion model.
#'
#' @param data **\[list\]** Data to run the model, passed as a list.
#' @inheritParams rstan::sampling
#' @param ... Additional arguments to pass to [sampling][rstan::sampling].
#'
#' @return
#' An object of class `stanfit` returned by [sampling][rstan::sampling].
#'

# Unexported routine

csdm_stan <- function(data, chains, iter, ...) {

  checkmate::assert_list(data)
  checkmate::assert_numeric(chains)
  checkmate::assert_numeric(iter)

  out <- rstan::sampling(stanmodels$nonlinear_cpue_grouped,
                         data = data,
                         chains = chains,
                         iter = iter, ...)

  return(out)
}
