
<!-- README.md is generated from README.Rmd. Please edit that file -->

# csdm

<!-- badges: start -->

[![R-CMD-check](https://github.com/pedersen-fisheries-lab/csdm/workflows/R-CMD-check/badge.svg)](https://github.com/pedersen-fisheries-lab/csdm/actions)
<!-- badges: end -->

The goal of csdm is to implement a bayesian catch saturation-depletion
model.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("pedersen-fisheries-lab/csdm")
```

## Example

1.  Let’s use the data provided in the package and taken from Delury’s
    population estimator data.

``` r
library(csdm)
delury <- csdm::delury_lobster
```

2.  Let’s run the model.

``` r
delury_model <- csdm(catch = cpue,
                     effort = traps,
                     biomass = ~1,
                     q = ~1,
                     s = ~1,
                     data = delury,
                     prior = list(B0_logmean_prior_sd = log(1000),
                                  B0_group_prior_logsd = log(100)),
                     upper =  c(B0 = 1e10, q = 1e-3, s = 100),
                     chains = 4,
                     iter = 1000)
#> 
#> SAMPLING FOR MODEL 'nonlinear_cpue_grouped' NOW (CHAIN 1).
#> Chain 1: 
#> Chain 1: Gradient evaluation took 0.000496 seconds
#> Chain 1: 1000 transitions using 10 leapfrog steps per transition would take 4.96 seconds.
#> Chain 1: Adjust your expectations accordingly!
#> Chain 1: 
#> Chain 1: 
#> Chain 1: Iteration:   1 / 1000 [  0%]  (Warmup)
#> Chain 1: Iteration: 100 / 1000 [ 10%]  (Warmup)
#> Chain 1: Iteration: 200 / 1000 [ 20%]  (Warmup)
#> Chain 1: Iteration: 300 / 1000 [ 30%]  (Warmup)
#> Chain 1: Iteration: 400 / 1000 [ 40%]  (Warmup)
#> Chain 1: Iteration: 500 / 1000 [ 50%]  (Warmup)
#> Chain 1: Iteration: 501 / 1000 [ 50%]  (Sampling)
#> Chain 1: Iteration: 600 / 1000 [ 60%]  (Sampling)
#> Chain 1: Iteration: 700 / 1000 [ 70%]  (Sampling)
#> Chain 1: Iteration: 800 / 1000 [ 80%]  (Sampling)
#> Chain 1: Iteration: 900 / 1000 [ 90%]  (Sampling)
#> Chain 1: Iteration: 1000 / 1000 [100%]  (Sampling)
#> Chain 1: 
#> Chain 1:  Elapsed Time: 17.4461 seconds (Warm-up)
#> Chain 1:                9.51881 seconds (Sampling)
#> Chain 1:                26.9649 seconds (Total)
#> Chain 1: 
#> 
#> SAMPLING FOR MODEL 'nonlinear_cpue_grouped' NOW (CHAIN 2).
#> Chain 2: 
#> Chain 2: Gradient evaluation took 0.000555 seconds
#> Chain 2: 1000 transitions using 10 leapfrog steps per transition would take 5.55 seconds.
#> Chain 2: Adjust your expectations accordingly!
#> Chain 2: 
#> Chain 2: 
#> Chain 2: Iteration:   1 / 1000 [  0%]  (Warmup)
#> Chain 2: Iteration: 100 / 1000 [ 10%]  (Warmup)
#> Chain 2: Iteration: 200 / 1000 [ 20%]  (Warmup)
#> Chain 2: Iteration: 300 / 1000 [ 30%]  (Warmup)
#> Chain 2: Iteration: 400 / 1000 [ 40%]  (Warmup)
#> Chain 2: Iteration: 500 / 1000 [ 50%]  (Warmup)
#> Chain 2: Iteration: 501 / 1000 [ 50%]  (Sampling)
#> Chain 2: Iteration: 600 / 1000 [ 60%]  (Sampling)
#> Chain 2: Iteration: 700 / 1000 [ 70%]  (Sampling)
#> Chain 2: Iteration: 800 / 1000 [ 80%]  (Sampling)
#> Chain 2: Iteration: 900 / 1000 [ 90%]  (Sampling)
#> Chain 2: Iteration: 1000 / 1000 [100%]  (Sampling)
#> Chain 2: 
#> Chain 2:  Elapsed Time: 17.2415 seconds (Warm-up)
#> Chain 2:                12.3746 seconds (Sampling)
#> Chain 2:                29.6161 seconds (Total)
#> Chain 2: 
#> 
#> SAMPLING FOR MODEL 'nonlinear_cpue_grouped' NOW (CHAIN 3).
#> Chain 3: 
#> Chain 3: Gradient evaluation took 0.000553 seconds
#> Chain 3: 1000 transitions using 10 leapfrog steps per transition would take 5.53 seconds.
#> Chain 3: Adjust your expectations accordingly!
#> Chain 3: 
#> Chain 3: 
#> Chain 3: Iteration:   1 / 1000 [  0%]  (Warmup)
#> Chain 3: Iteration: 100 / 1000 [ 10%]  (Warmup)
#> Chain 3: Iteration: 200 / 1000 [ 20%]  (Warmup)
#> Chain 3: Iteration: 300 / 1000 [ 30%]  (Warmup)
#> Chain 3: Iteration: 400 / 1000 [ 40%]  (Warmup)
#> Chain 3: Iteration: 500 / 1000 [ 50%]  (Warmup)
#> Chain 3: Iteration: 501 / 1000 [ 50%]  (Sampling)
#> Chain 3: Iteration: 600 / 1000 [ 60%]  (Sampling)
#> Chain 3: Iteration: 700 / 1000 [ 70%]  (Sampling)
#> Chain 3: Iteration: 800 / 1000 [ 80%]  (Sampling)
#> Chain 3: Iteration: 900 / 1000 [ 90%]  (Sampling)
#> Chain 3: Iteration: 1000 / 1000 [100%]  (Sampling)
#> Chain 3: 
#> Chain 3:  Elapsed Time: 15.9817 seconds (Warm-up)
#> Chain 3:                7.96601 seconds (Sampling)
#> Chain 3:                23.9477 seconds (Total)
#> Chain 3: 
#> 
#> SAMPLING FOR MODEL 'nonlinear_cpue_grouped' NOW (CHAIN 4).
#> Chain 4: 
#> Chain 4: Gradient evaluation took 0.000565 seconds
#> Chain 4: 1000 transitions using 10 leapfrog steps per transition would take 5.65 seconds.
#> Chain 4: Adjust your expectations accordingly!
#> Chain 4: 
#> Chain 4: 
#> Chain 4: Iteration:   1 / 1000 [  0%]  (Warmup)
#> Chain 4: Iteration: 100 / 1000 [ 10%]  (Warmup)
#> Chain 4: Iteration: 200 / 1000 [ 20%]  (Warmup)
#> Chain 4: Iteration: 300 / 1000 [ 30%]  (Warmup)
#> Chain 4: Iteration: 400 / 1000 [ 40%]  (Warmup)
#> Chain 4: Iteration: 500 / 1000 [ 50%]  (Warmup)
#> Chain 4: Iteration: 501 / 1000 [ 50%]  (Sampling)
#> Chain 4: Iteration: 600 / 1000 [ 60%]  (Sampling)
#> Chain 4: Iteration: 700 / 1000 [ 70%]  (Sampling)
#> Chain 4: Iteration: 800 / 1000 [ 80%]  (Sampling)
#> Chain 4: Iteration: 900 / 1000 [ 90%]  (Sampling)
#> Chain 4: Iteration: 1000 / 1000 [100%]  (Sampling)
#> Chain 4: 
#> Chain 4:  Elapsed Time: 17.1164 seconds (Warm-up)
#> Chain 4:                12.199 seconds (Sampling)
#> Chain 4:                29.3154 seconds (Total)
#> Chain 4:
#> Warning: There were 47 divergent transitions after warmup. See
#> http://mc-stan.org/misc/warnings.html#divergent-transitions-after-warmup
#> to find out why this is a problem and how to eliminate them.
#> Warning: Examine the pairs() plot to diagnose sampling problems
```
