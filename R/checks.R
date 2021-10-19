
# Function to check the input variables
check_input_vars <- function(catch, effort, data) {

  checkmate::test_string(catch)
  checkmate::test_string(effort)
  checkmate::test_data_frame(data)

  if(!checkmate::test_choice(catch, names(data))){
    stop("Variable 'catch' must be a column of 'data'.")
  }

  if(!checkmate::test_choice(effort, names(data))){
    stop("Variable 'effort' must be a column of 'data'.")
  }

}

# Function to check the validity of catch and effort vectors
check_input_vars_length <- function(catch, effort){

  checkmate::test_vector(catch)
  checkmate::test_vector(effort)

  stopifnot(length(catch) == length(effort))

  if(!checkmate::test_numeric(catch)) {
    stop("The 'catch' variable has to be numeric.")
  }

  if(!checkmate::test_numeric(effort)) {
    stop("The 'effort' variable has to be numeric.")
  }

  if(any(is.na(catch)) | any(is.na(effort)) |
     any(is.nan(catch)) | any(is.nan(effort))) {
    stop("The 'catch' or 'effort' variables containes missing values")
  }

}

# Function to check the validity of factors
check_factors <- function(ts_fac, q_fac, s_fac){

  if(!is.factor(ts_fac)) {
    stop("Time series grouping variable has to be a factor.")
  }

  if(!is.factor(q_fac)) {
    stop("q grouping variable has to be a factor.")
  }

  if(!is.factor(s_fac)) {
    stop("s grouping variable has to be a factor.")
  }

  G_ts <- length(levels(ts_fac))
  G_q <- length(levels(q_fac))
  G_s <- length(levels(s_fac))

  if(G_ts > length(unique(ts_fac))) {
    warning("There are levels in the time series group (ts_fac) that are not present in the data.")
  }

  if(G_q  > length(unique(q_fac))) {
    warning("There are levels in the q group (q_fac) that are not present in the data.")
  }

  if(G_s  > length(unique(s_fac))) {
    warning("There are levels in the s group (s_fac) that are not present in the data.")
  }

}

# Function to check the validity of priors supplied, to be written
check_priors <- function(prior_list) {
  return(NULL)
}

# Function to check whether 2 factors are nested
# Code adapted from lme4::isNested(). Readability improved slightly.
check_nested <- function(fact1, fact2, var1){

  stopifnot(length(fact1) == length(fact2))

  k1 <- length(levels(fact1))
  k2 <- length(levels(fact2))

  sm <- as(new("ngTMatrix",
               i = as.integer(fact2) - 1L,
               j = as.integer(fact1) - 1L,
               Dim = c(k2, k1)),
           "CsparseMatrix")

  is_nested <- all(sm@p[2:(k1+1L)] - sm@p[1:k1] <= 1L)

  if(!is_nested){
    stop(paste0("Variable ", var1, " improperly nested."))
  }

}
