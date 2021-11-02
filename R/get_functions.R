
# Get functions -----------------------------------------------------------

#' @export
get_cpue_fit <- function(stan_fit){

  cpue_fit <- csdm_delury %>%
    tidybayes::spread_draws(cpue_fit[t]) %>%
    tidybayes::median_qi(.) %>%
    dplyr::bind_cols(delury) %>%
    dplyr::select(-.data$t)

  return(cpue_fit)

}

#' @export
get_biomass <- function(stan_fit){

  biomass <- csdm_delury %>%
    spread_draws(biomass_ts[t]) %>%
    median_qi(.) %>%
    dplur::bind_cols(csdm::delury) %>%
    select(-.data$t)

  return(biomass)

}
