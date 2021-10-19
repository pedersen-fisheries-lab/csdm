#' Bayesian catch saturation-depletion model
#'
#' Catch saturation-depletion model.
#'
#' @param catch **\[name\]** Variable name for catch (catch).
#' @param effort **\[name\]** Variable name for effort.
#' @param biomass **\[name\]** Formula for biomass. If not provided, inferred
#'   from the formula for parameter q.
#' @param q **\[formula\]** Formula for parameter q.
#' @param s **\[formula\]** Formula for parameter s.
#' @param data **\[data.frame\]** The timeseries data to fit the model with.
#' @param lower **\[named numeric vector\]** Lower bounds of catch estimate.
#' @param upper **\[named numeric vector\]** Upper bounds of catch estimate.
#' @param priors **\[NA\]** List of priors.
#' @param ... Additional arguments to pass to [sampling][rstan::sampling].
#'
#' @return
#' An object of class `stanfit` returned by `rstan::sampling`.
#'
#' @details
#' TODO: describe model + priors.
#'
#' @export
csdm <- function(catch = catch,
                 effort = effort,
                 biomass = NULL,
                 q = ~1,
                 s = ~1,
                 data,
                 lower = c(B0 = 100, q = 1e-10, s = 1),
                 upper = c(B0 = 1e10, q = 1e-3, s = 100),
                 priors = NULL,
                 ...) {

  # -------------------------------------------------------------------------
  # Perform the necessary check on the inputs

  catch_var <- deparse(substitute(catch))
  effort_var <- deparse(substitute(effort))

  check_input_vars(catch_var, effort_var, data)

  catch <- data[[catch_var]]
  effort <- data[[effort_var]]

  check_input_vars_length(catch, effort)

  # -------------------------------------------------------------------------
  # Verify the parameter formulas
  #
  # if B0 is provided, check q is nested
  # otherwise, apply q nesting to B0

  # Transforming each level
  q_fac <- get_factor(q, data)
  s_fac <- get_factor(s, data)

  if (!is.null(biomass)) {
    ts_fac <- get_factor(biomass, data)
  } else {
    ts_fac <- q_fac
  }

  check_factors(ts_fac, q_fac, s_fac)

  G_ts <- length(levels(ts_fac))
  G_q <- length(levels(q_fac))
  G_s <- length(levels(s_fac))

  N <- nrow(data)
  G <- c(G_ts, G_q, G_s)

  # -------------------------------------------------------------------------
  # Checking for nesting of the time-series factor.

  check_nested(ts_fac, q_fac, "q")
  check_nested(ts_fac, s_fac, "s")

  ts_numeric <- as.numeric(ts_fac)
  q_numeric <- as.numeric(q_fac)
  s_numeric <- as.numeric(s_fac)

  gg <- matrix(c(ts_numeric, q_numeric, s_numeric),
               byrow = FALSE, ncol = 3)

  # -------------------------------------------------------------------------
  # Manipulate priors

  model_priors <- get_default_priors()

  if (!is.null(priors)){

    if (!all(names(priors) %in% names(model_priors))) {
      stop(paste("priors parameters ",
                 names(priors)[which(!names(priors)%in%names(model_priors))],
                 " are not priors parameters in this model.",sep = " "))
    }

    model_priors[names(priors)] <- priors[names(priors)]

  }

  # -------------------------------------------------------------------------
  # Setting up the model data

  model_data <- c(list(N = N,
                       G = G,
                       gg = gg,
                       effort = effort,
                       cpue_obs = catch,
                       B0_range = c(lower[["B0"]], upper[["B0"]]),
                       lnq_range = c(log(lower[["q"]]), log(upper[["q"]])),
                       lns_range = c(log(lower[["s"]]), log(upper[["s"]]))),
                  model_priors)

  model_samples <- csdm_stan(data = model_data, ...)

  return(model_samples)
}
