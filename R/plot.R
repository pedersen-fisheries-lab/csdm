
# Plotting functions ------------------------------------------------------

#' @export
plot.csdm_fit <- function(x, y, ...){

  get_cpue_fit(delury_model)%>%
    ggplot2::ggplot() +
    ggplot2::geom_point(aes(x=t, y=cpue)) +
    ggplot2::geom_line(aes(x=t, y=cpue_fit)) +
    ggplot2::labs(x = "Time", y = "CPUE")

}
