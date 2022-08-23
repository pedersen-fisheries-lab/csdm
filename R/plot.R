
# Plotting functions ------------------------------------------------------

#' Plot model output
#'
#' Plots the output of the model.
#'
#' @param x **\[csdm_fit\]** The csdm_fit object.
#' @param y Not used
#' @param ... Not used
#'
#' @return
#' A ggplot.
#'
#' @examples
#' \dontrun{
#' plot(delury_model)
#' plot_biomass(delury_model)
#' }
#'
#' @export
plot.csdm_fit <- function(x, y, ...){

  checkmate::assert_class(x, "csdm_fit")

  the_plot <- get_cpue_fit(x) %>%
    ggplot2::ggplot() +
    ggplot2::geom_point(ggplot2::aes(x=.data$t, y=.data$cpue)) +
    ggplot2::geom_line(ggplot2::aes(x=.data$t, y=.data$cpue_fit),
                       col = "red") +
    ggplot2::labs(x = "Time", y = "CPUE")

  return(the_plot)
}

#' Make a biomass plot
#'
#' Produces a generic plot of biomass from the model
#'
#' @param x **\[csdm_fit\]** The csdm_fit object.
#'
#' @return
#' A ggplot of biomass.
#'
#' @examples
#' \dontrun{
#' plot(delury_model)
#' plot_biomass(delury_model)
#' }
#'
#' @export
plot_biomass <- function(x){

  checkmate::assert_class(x, "csdm_fit")

  the_plot <- get_biomass(x) %>%
    ggplot2::ggplot(ggplot2::aes(x=.data$date, y=.data$biomass)) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::labs(x = "Time", y = "Biomass")

  return(the_plot)
}
