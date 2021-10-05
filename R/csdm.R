#' Bayesian catch saturation-depletion model
#'
#' Catch saturation-depletion model.
#'
#' @param data **\[data.frame\]** The data.
#' @param cpue_var **\[name\]** Variable of the data corresponding to cpue.
#' @param effort_var **\[name\]** Variable of the data corresponding to effort.
#' @param timeseries_formula **\[formula\]** Formula for time series grouping.
#' @param q_formula **\[formula\]** Formula for q.
#' @param s_formula **\[formula\]** Formula for s.
#' @param lower **\[named numeric vector\]** Lower bounds of catch estimate.
#' @param upper **\[named numeric vector\]** Upper bounds of catch estimate.
#' @param prior **\[NA\]** NULL for now
#' @param n_chains **\[numeric\]** Number of chains, default to 4.
#' @param n_samples **\[numeric\]** Number of samples, default to 500 (TBC).
#'
#' @return
#' An object of class `stanfit` returned by `rstan::sampling`.
#'
#' @export
csdm <- function(data,
                 cpue_var = cpue,
                 effort_var = effort,
                 timeseries_formula = ~1,
                 q_formula = ~1,
                 s_formula = ~1,
                 lower = c(B0 = 100, q = 1e-10, s = 1),
                 upper = c(B0 = 1e10, q = 1e-3, s = 100),
                 prior = NULL,
                 n_chains = 4,
                 n_samples = 500) {

  cpue_var <- rlang::enquo(cpue_var)
  effort_var <- rlang::enquo(effort_var)
  cpue <- dplyr::select(data,!!cpue_var)[[1]]
  effort <- dplyr::select(data,!!effort_var)[[1]]

  #Initial error checking
  if(!is.numeric(cpue)) stop("CPUE has to be a numeric column")
  if(!is.numeric(effort)) stop("cumulative_effort has to be a numeric column")
  stopifnot(length(cpue)==length(effort))
  if(any(is.na(cpue))|any(is.na(effort))|any(is.nan(cpue))|any(is.nan(effort))) stop("NA and NaN values are not valid entries for CPUE or cumulative effort")

  # transforming each level
  ts_fac <- get_factor(timeseries_formula, data)
  q_fac <- get_factor(q_formula, data)
  s_fac <- get_factor(s_formula, data)

  if(!is.factor(ts_fac)) stop("Time series grouping variable has to be a factor")
  if(!is.factor(q_fac)) stop("q grouping variable has to be a factor")
  if(!is.factor(s_fac)) stop("s grouping variable has to be a factor")

  G_ts <- length(levels(ts_fac))
  G_q <- length(levels(q_fac))
  G_s <- length(levels(s_fac))

  N <- nrow(data)
  G <- c(G_ts, G_q, G_s)

  if(G_ts > length(unique(ts_fac))) warning("There are levels in the time series group (ts_fac) that are not present in the data")
  if(G_q  > length(unique(q_fac))) warning("There are levels in the q group (q_fac) that are not present in the data")
  if(G_s  > length(unique(s_fac))) warning("There are levels in the s group (s_fac) that are not present in the data")

  # Checking for nesting of the time-series factor. Currently using the isNested
  # function from lme4 to check this, but I'll just duplicate this function for
  # the final package, to cut dependencies down
  if(!lme4::isNested(ts_fac, q_fac)) stop("Time series grouping variable has to be nested in the q grouping variable")
  if(!lme4::isNested(ts_fac, s_fac)) stop("Time series grouping variable has to be nested in the s grouping variable")

  ts_numeric <- as.numeric(ts_fac)
  q_numeric <- as.numeric(q_fac)
  s_fac <- as.numeric(s_fac)

  gg <- matrix(c(ts_numeric,q_numeric,s_fac),byrow = FALSE,ncol = 3)

  #setting up the model data
  model_data <- list(N=N,
                     G = G,
                     gg = gg,
                     effort = effort,
                     cpue_obs = cpue,
                     B0_range = c(lower[["B0"]], upper[["B0"]]),
                     lnq_range = c(log(lower[["q"]]), log(upper[["q"]])),
                     lns_range = c(log(lower[["s"]]), log(upper[["s"]])))

  #getting priors set up to combine with the model data
  prior_defaults <- list(
    B0_logmean_prior = log(50000), #assuming about 50,000 kg as a default
    lnq_mean_prior = log(1e-5),
    lns_mean_prior = log(30),

    #assuming a large amount of variability around estimated biomasses; basically
    #the standard deviation is +/- 5 times the prior mean for parameters, and
    # about a 10-fold variation in B0
    B0_logmean_prior_sd = log(10),
    lnq_mean_prior_sd = log(5),
    lns_mean_prior_sd = log(5),

    #these are the priors on the estimated standard deviations for between-group
    #variability; I've put relatively tight priors on these, as otherwise the
    #model is liable to explode
    B0_group_prior_logsd = log(5),
    lnq_group_prior_sd   = log(1.5),
    lns_group_prior_sd   = log(1.5),

    #prior for the standard deviation of process error around observed cpue
    cpue_process_error_prior_sd = 1
  )

  if(!all(names(prior)%in%names(prior_defaults))) stop(paste("prior parameters ", names(prior)[which(!names(prior)%in%names(prior_defaults))], " are not prior parameters in this model.",sep = " "))

  model_priors <- prior_defaults
  model_priors[names(prior)] <- prior[names(prior)]

  model_data <- c(model_data, model_priors)

  model_samples <- csdm_stan(data = model_data,
                             chains = n_chains,
                             iter = n_samples)
  return(model_samples)
}
