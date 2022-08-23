
# Imports -----------------------------------------------------------------

#' @importFrom rlang .data
utils::globalVariables(c("biomass_ts"))
NULL

# CSDM class object -------------------------------------------------------

#' Create a csdm_fit object
#'
#' Creates a csdm_fit object.
#'
#' @param data **\[data.frame\]** The model data.
#' @param fit **\[stanfit\]** The model fit.
#'
#' @return
#' An object of S3 class csdm_fit.
#'
#' @examples
#' \dontrun{
#' csdm_fit <- new_csdm_fit(data = data, fit = model_fit)
#' }
#'
#' @export
new_csdm_fit <- function(data, fit){

  stopifnot(is.data.frame(data))
  stopifnot(class(fit) == "stanfit")

  structure(list(data = data,
                 fit = fit), class = "csdm_fit")

}
