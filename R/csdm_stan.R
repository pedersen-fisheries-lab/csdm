#' Bayesian catch saturation-depletion model (stan routine)
#'
#' Stan routine for the catch saturation-depletion model.
#'
#' @param data **\[list\]** Data to run the model, passed as a list.
#' @param ... Additional arguments to pass to [sampling][rstan::sampling].
#'
#' @return
#' An object of class `stanfit` returned by [sampling][rstan::sampling].
#'
#' @examples
#' \dontrun{
#' model_fit <- csdm_stan(data = model_data, ...)
#' }
#'
csdm_stan <- function(data, ...) {

  checkmate::assert_list(data)

  out <- rstan::sampling(stanmodels$nonlinear_cpue_grouped,
                         data = data, ...)
  return(out)
}
