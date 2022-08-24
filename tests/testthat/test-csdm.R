test_that("package fit csdm model correctly", {
  fit <- csdm(catch = cpue,
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
  checkmate::expect_class(fit, "csdm_fit")

  checkmate::expect_data_frame(get_cpue_fit(fit))

  checkmate::get_biomass(get_cpue_fit(fit))

  checkmate::expect_class(plot(delury_model), "gg")

  checkmate::expect_class(plot_biomass(delury_model), "gg")
})
