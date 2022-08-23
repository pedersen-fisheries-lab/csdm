
# Get functions -----------------------------------------------------------

#' Extract fit from a csdm_fit object
#'
#' @param csdm_fit **\[csdm_fit\]** The csdm_fit object.
#'
#' @return
#' A data.frame with the model fit.
#'
#' @examples
#' \dontrun{
#' get_cpue_fit(model_fit)
#' }
#'
#' @export
get_cpue_fit <- function(csdm_fit){

  checkmate::assert_class(csdm_fit, "csdm_fit")

  cpue_fit <- csdm_fit$fit %>%
    tidybayes::spread_draws(cpue_fit[t]) %>%
    tidybayes::median_qi() %>%
    dplyr::bind_cols(csdm_fit$data)

  return(cpue_fit)

}

#' Extract biomass from a csdm_fit object
#'
#' @param csdm_fit **\[csdm_fit\]** The csdm_fit object.
#'
#' @return
#' A data.frame with the model biomass
#'
#' @examples
#' \dontrun{
#' get_biomass(model_fit)
#' }
#'
#' @export
get_biomass <- function(csdm_fit){

  checkmate::assert_class(csdm_fit, "csdm_fit")

  biomass <- csdm_fit$fit %>%
    tidybayes::spread_draws(biomass_ts[t]) %>%
    tidybayes::median_qi() %>%
    dplyr::bind_cols(csdm_fit$data) %>%
    dplyr::select(-.data$t) %>%
    dplyr::rename(biomass = .data$biomass_ts)

  return(biomass)

}
