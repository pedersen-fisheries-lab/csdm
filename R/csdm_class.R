
# CSDM class object -------------------------------------------------------

#' @export
new_csdm_fit <- function(data, fit){

  stopifnot(is.data.frame(data))
  stopifnot(class(fit) == "stanfit")

  structure(list(data = data,
                 fit = fit), class = "csdm_fit")

}
