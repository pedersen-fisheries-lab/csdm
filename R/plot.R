
# Plotting functions ------------------------------------------------------

#' @export
plot.csdm_fit <- function(x, y, ...){

  the_plot <- get_cpue_fit(delury_model) %>%
    ggplot2::ggplot() +
    ggplot2::geom_point(ggplot2::aes(x=.data$t, y=.data$cpue)) +
    ggplot2::geom_line(ggplot2::aes(x=.data$t, y=.data$cpue_fit),
                       col = "red") +
    ggplot2::labs(x = "Time", y = "CPUE")

  return(the_plot)
}

#' @export
plot_biomass <- function(x){

  checkmate::assert_class(x, "csdm_fit")

  the_plot <- get_biomass(delury_model) %>%
    ggplot2::ggplot(ggplot2::aes(x=.data$date, y=.data$biomass)) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::labs(x = "Time", y = "Biomass")

  return(the_plot)
}
