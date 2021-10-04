functions {
real[]  saturating_dynamics(real time, real[] state, real[] theta, real[] x_r, int[] x_i){
  real dxdt[1];
  //assumes that the parameters are in untransformed form, and are in the order q, s
  dxdt[1] = -state[1]*theta[1]/(1+state[1]*theta[1]/theta[2]);
  return dxdt;
}
}

data {
  int<lower=0> N; //number of observations
  int<lower=0> G[3]; //vector of grouping levels. G[1] is the number of groups
  //for the time series,  G[2] for lnq, and G[3] for lns
  //NOTE: This strongly assumes nesting, so that all time series groups are fully nested
  //in the groups for B0, lnq, and lns (although these variables can be crossed with each other)
  //gg indicates the grouping levels for each parameter. first column: the time series/B0
  // second column is for lnq, and third is for lns
  // Check ordering
  int<lower=1,upper=G[1]> gg[N,3];
  vector[N] cpue_obs;
  real effort[N];
  real lnq_range[2];
  real lns_range[2];
  real B0_range[2];

  //These are the means of the priors for B0, lnq, and lns
  real<lower=log(B0_range[1]), upper= log(B0_range[2])> B0_logmean_prior;
  real<lower=lnq_range[1], upper= lnq_range[2]> lnq_mean_prior;
  real<lower=lns_range[1], upper= lns_range[2]> lns_mean_prior;

  //global standard deviations for parameter priors (assumes normal distributions)
  real<lower=0> B0_logmean_prior_sd;
  real<lower=0> lnq_mean_prior_sd;
  real<lower=0> lns_mean_prior_sd;

  //standard deviations for groupwise variability in these term
  real<lower=0> B0_group_prior_logsd;
  real<lower=0> lnq_group_prior_sd;
  real<lower=0> lns_group_prior_sd;

  real<lower=0> cpue_process_error_prior_sd;
}

transformed data{
  vector[N] caught;
  vector[G[1]] total_caught;
  real x_r[0];
  int x_i[0];
  int gg_start[G[1]];
  int gg_end[G[1]];
  int gg_length[G[1]];



  // NOTE: This very strongly assumes that the groups are ordered sequentially, so that
  // all values for group 1 occur before group 2 (etc.) and all values for each group are
  // arranged in order of ascending cumulative effort
  {
    int current_gg = 1;
    gg_start[1] = 1;
    for(n in 1:(N-1)){
      if(gg[n+1,1] > gg[n,1]){
        gg_end[current_gg] = n;
        gg_start[current_gg+1] = n+1;
        current_gg = current_gg + 1;
      }
    }
  }
  gg_end[G[1]] = N;
  for(g in 1:G[1]){
    gg_length[g] = gg_end[g] - gg_start[g] + 1;
  }
  //calculates the catch in any given point in the series as the total effort
  //in that period times the CPUE observed
  for(i in 1:N){
    caught[i] = effort[i]*cpue_obs[i];
  }

  // calculates the total catch for each time series. This will be the minimum
  // possible starting biomass for the time series (you can't catch more than
  // the actual starting biomass!!)
  for(i in 1:G[1]){
    total_caught[i] = sum(caught[gg_start[i]:gg_end[i]]);
  }

}

parameters {
  real<lower=0> cpue_process_error;
  real<lower=B0_range[1], upper= B0_range[2]> B0_mean;
  real<lower=lnq_range[1], upper= lnq_range[2]> lnq_mean;
  real<lower=lns_range[1], upper= lns_range[2]> lns_mean;
  real<lower=0> B0_group_logsd;
  real<lower=0> lnq_group_sd;
  real<lower=0> lns_group_sd;
  vector<lower=0, upper= B0_range[2]>[G[1]]  B0_raw;
  vector<lower=lnq_range[1], upper= lnq_range[2]>[G[2]]  lnq;
  vector<lower=lns_range[1], upper= lns_range[2]>[G[3]]  lns;
}

transformed parameters{
  vector[G[2]] q;
  vector[G[3]] s;
  //this makes sure that the intial biomass is *at least* as big as the total caught
  vector[G[1]]  B0 = B0_raw + total_caught;
  vector[N] biomass_ts;
  for(i in 1:G[1]){
    biomass_ts[gg_start[i]] = B0[i];
    for(j in 1:(gg_length[i]-1)){
      //the biomass time series is B0 minus the observed catch history for
      //each group level
      biomass_ts[gg_start[i]+j] = biomass_ts[gg_start[i]+j-1]-caught[gg_start[i]+j-1];
    }
  }

  q = exp(lnq);
  s = exp(lns);
}

model {
  real dyn_pars[2];
  real state[1];
  real biomass_expected[N,1];
  vector[N] cpue_expected;

  //Priors for global parameters
  B0_mean ~ lognormal(B0_logmean_prior,B0_logmean_prior_sd);
  lnq_mean ~ normal(lnq_mean_prior,lnq_mean_prior_sd);
  lns_mean ~ normal(lns_mean_prior,lns_mean_prior_sd);

  //Priors for group-specific devations from global parameters
  B0_group_logsd ~ normal(0, B0_group_prior_logsd);
  lnq_group_sd ~ normal(0, lnq_group_prior_sd);
  lns_group_sd  ~ normal(0, lns_group_prior_sd);

  //Priors for group-level parameters
  B0 ~ lognormal(log(B0_mean),B0_group_logsd);
  lnq ~ normal(lnq_mean,lnq_group_sd);
  lns ~ normal(lns_mean,lns_group_sd);

  //prior for process error
  cpue_process_error ~ normal(0, cpue_process_error_prior_sd);

  for(g in 1:G[1]){
    int g_start = gg_start[g];
    int g_end   = gg_end[g];
    //takes the first entries of gg matrix as the group level for the value of B0, q, and s.
    //this is where the nested grouping level really bites.
    int B0_current = gg[g_start,1];
    int lnq_current  = gg[g_start,2];
    int lns_current  = gg[g_start,3];
    dyn_pars[1] = q[lnq_current];
    dyn_pars[2] = s[lns_current];
    for(n in g_start:g_end){
      state[1] = biomass_ts[n];
      biomass_expected[n:n] = integrate_ode_rk45(saturating_dynamics, state,0,
                                  effort[n:n],dyn_pars,x_r,x_i);

      cpue_expected[n] = (biomass_ts[n]-biomass_expected[n,1])/effort[n];
    }
  }

  cpue_obs ~ normal(cpue_expected, cpue_process_error);
}

generated quantities{
    vector[N] cpue_fit; //this returns the fitted time series of cpue
  {
    real biomass_expected_ts[N,1];
    for(g in 1:G[1]){
      real dyn_pars[2];
      real state[1];
      int g_start = gg_start[g];
      int g_end   = gg_end[g];
      //takes the first entries of gg matrix as the group level for the value of lnB0, q, and s.
      //this is where the nested grouping level really bites.
      int B0_current = gg[g_start,1];
      int lnq_current  = gg[g_start,2];
      int lns_current  = gg[g_start,3];
      state[1] = B0[B0_current];
      dyn_pars[1] = q[lnq_current];
      dyn_pars[2] = s[lns_current];
      biomass_expected_ts[g_start:g_end] = integrate_ode_rk45(saturating_dynamics, state,0,
                                  cumulative_sum(effort[g_start:g_end]),dyn_pars,x_r,x_i);
      for(n in g_start:g_end){
        cpue_fit[n] = q[lnq_current]*biomass_expected_ts[n,1]/(1+q[lnq_current]/s[lns_current]*biomass_expected_ts[n,1]);
      }
  }

  }
}
