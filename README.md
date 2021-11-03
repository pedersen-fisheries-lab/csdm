
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
#> Chain 1: Gradient evaluation took 0.000571 seconds
#> Chain 1: 1000 transitions using 10 leapfrog steps per transition would take 5.71 seconds.
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
#> Chain 1:  Elapsed Time: 15.1841 seconds (Warm-up)
#> Chain 1:                6.70903 seconds (Sampling)
#> Chain 1:                21.8931 seconds (Total)
#> Chain 1: 
#> 
#> SAMPLING FOR MODEL 'nonlinear_cpue_grouped' NOW (CHAIN 2).
#> Chain 2: 
#> Chain 2: Gradient evaluation took 0.000497 seconds
#> Chain 2: 1000 transitions using 10 leapfrog steps per transition would take 4.97 seconds.
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
#> Chain 2:  Elapsed Time: 14.0855 seconds (Warm-up)
#> Chain 2:                6.95937 seconds (Sampling)
#> Chain 2:                21.0449 seconds (Total)
#> Chain 2: 
#> 
#> SAMPLING FOR MODEL 'nonlinear_cpue_grouped' NOW (CHAIN 3).
#> Chain 3: 
#> Chain 3: Gradient evaluation took 0.000546 seconds
#> Chain 3: 1000 transitions using 10 leapfrog steps per transition would take 5.46 seconds.
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
#> Chain 3:  Elapsed Time: 14.7914 seconds (Warm-up)
#> Chain 3:                7.58095 seconds (Sampling)
#> Chain 3:                22.3723 seconds (Total)
#> Chain 3: 
#> 
#> SAMPLING FOR MODEL 'nonlinear_cpue_grouped' NOW (CHAIN 4).
#> Chain 4: 
#> Chain 4: Gradient evaluation took 0.000522 seconds
#> Chain 4: 1000 transitions using 10 leapfrog steps per transition would take 5.22 seconds.
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
#> Chain 4:  Elapsed Time: 12.9401 seconds (Warm-up)
#> Chain 4:                5.63011 seconds (Sampling)
#> Chain 4:                18.5702 seconds (Total)
#> Chain 4:
#> Warning: There were 139 divergent transitions after warmup. See
#> http://mc-stan.org/misc/warnings.html#divergent-transitions-after-warmup
#> to find out why this is a problem and how to eliminate them.
#> Warning: Examine the pairs() plot to diagnose sampling problems
#> Warning: Bulk Effective Samples Size (ESS) is too low, indicating posterior means and medians may be unreliable.
#> Running the chains for more iterations may help. See
#> http://mc-stan.org/misc/warnings.html#bulk-ess
#> Warning: Tail Effective Samples Size (ESS) is too low, indicating posterior variances and tail quantiles may be unreliable.
#> Running the chains for more iterations may help. See
#> http://mc-stan.org/misc/warnings.html#tail-ess
```

3.  You can extract the fit for cpue, as well as the biomass estimate.

``` r
get_cpue_fit(delury_model)
#> # A tibble: 33 × 14
#>        t cpue_fit .lower .upper .width .point .interval  date catch_pounds traps
#>    <int>    <dbl>  <dbl>  <dbl>  <dbl> <chr>  <chr>     <int>        <int> <int>
#>  1     1    0.957  0.912  1.01    0.95 median qi            2          147   200
#>  2     2    0.954  0.910  1.01    0.95 median qi            3         2796  3780
#>  3     3    0.950  0.906  1.00    0.95 median qi            4         6888  7174
#>  4     4    0.943  0.901  0.992   0.95 median qi            5         7723  8850
#>  5     5    0.938  0.896  0.985   0.95 median qi            8         5330  5793
#>  6     6    0.929  0.890  0.973   0.95 median qi            9         8839  9504
#>  7     7    0.923  0.884  0.964   0.95 median qi           10         6324  6655
#>  8     8    0.919  0.881  0.959   0.95 median qi           11         3569  3685
#>  9     9    0.910  0.874  0.948   0.95 median qi           12         8120  8202
#> 10    10    0.900  0.864  0.936   0.95 median qi           13         8084  8585
#> # … with 23 more rows, and 4 more variables: cpue <dbl>, traps_cum <int>,
#> #   cpue_l <dbl>, cpue_l10 <dbl>
```

``` r
get_biomass(delury_model)
#> # A tibble: 33 × 13
#>    biomass  .lower .upper .width .point .interval  date catch_pounds traps  cpue
#>      <dbl>   <dbl>  <dbl>  <dbl> <chr>  <chr>     <int>        <int> <int> <dbl>
#>  1 172646. 165021. 1.89e5   0.95 median qi            2          147   200  0.74
#>  2 172498. 164873. 1.89e5   0.95 median qi            3         2796  3780  0.74
#>  3 169701. 162076. 1.86e5   0.95 median qi            4         6888  7174  0.96
#>  4 162814. 155189. 1.80e5   0.95 median qi            5         7723  8850  0.87
#>  5 155115. 147489. 1.72e5   0.95 median qi            8         5330  5793  0.92
#>  6 149785. 142160. 1.67e5   0.95 median qi            9         8839  9504  0.93
#>  7 140946. 133321. 1.58e5   0.95 median qi           10         6324  6655  0.95
#>  8 134624. 126999. 1.51e5   0.95 median qi           11         3569  3685  0.97
#>  9 131050. 123425. 1.48e5   0.95 median qi           12         8120  8202  0.99
#> 10 122930. 115305. 1.40e5   0.95 median qi           13         8084  8585  0.94
#> # … with 23 more rows, and 3 more variables: traps_cum <int>, cpue_l <dbl>,
#> #   cpue_l10 <dbl>
```

4.  You can also get default plots for cpue and biomass.

``` r
plot(delury_model)
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

``` r
plot_biomass(delury_model)
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />
