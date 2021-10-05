
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
