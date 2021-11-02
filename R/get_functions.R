
# Get functions -----------------------------------------------------------

#' @export
get_cpue_fit <- function(csdm_fit){

  cpue_fit <- csdm_fit$fit %>%
    tidybayes::spread_draws(cpue_fit[t]) %>%
    tidybayes::median_qi(.) %>%
    dplyr::bind_cols(csdm_fit$data) %>%
    dplyr::select(-.data$t)

  return(cpue_fit)

}

#' @export
get_biomass <- function(csdm_fit){

  biomass <- csdm_fit$fit %>%
    tidybayes::spread_draws(biomass_ts[t]) %>%
    tidybayes::median_qi(.) %>%
    dplyr::bind_cols(csdm_fit$data) %>%
    dplyr::select(-.data$t) %>%
    dplyr::rename(biomass = .data$biomass_ts)

  return(biomass)

}
