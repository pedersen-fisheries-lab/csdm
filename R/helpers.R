
# Helper to get the factor within data (legacy)
get_factor <- function(formula, data, keep_all_levels = FALSE){

  N <- nrow(data)

  if (formula == ~1) {

    out <- factor(rep(1, times = N))
    f_vars <- "intercept"

  } else {

    f_terms <- stats::terms(formula,data= data)

    if (length(attr(f_terms, "term.labels"))>1) {
      stop(paste0("Currently, only single variables (e.g. ~ a) or pure",
                  " interaction terms (e.g. ~ a:b) are supported for",
                  " parameter model formulas"))
    }

    f_vars <- attr(f_terms,"variables")
    out <- with(data, interaction(eval(f_vars), drop = T,sep = ":"))

  }

  attr(out, "variables") <- f_vars

  return(out)
}

# Function to check the validity of priors supplied, to be written
check_priors <- function(prior_list) {
  return(NULL)
}

# Get the default priors
get_default_priors <- function(){
  list(
    # Assuming about 50,000 kg as a default
    B0_logmean_prior = log(50000),
    lnq_mean_prior   = log(1e-5),
    lns_mean_prior   = log(30),

    # Assuming a large amount of variability around estimated biomasses; basically
    # the standard deviation is +/- 5 times the prior mean for parameters, and
    # about a 10-fold variation in B0
    B0_logmean_prior_sd = log(10),
    lnq_mean_prior_sd   = log(5),
    lns_mean_prior_sd   = log(5),

    # These are the priors on the estimated standard deviations for between-group
    # variability; I've put relatively tight priors on these, as otherwise the
    # model is liable to explode
    B0_group_prior_logsd = log(5),
    lnq_group_prior_sd   = log(1.5),
    lns_group_prior_sd   = log(1.5),

    # Prior for the standard deviation of process error around observed cpue
    cpue_process_error_prior_sd = 1
  )
}
