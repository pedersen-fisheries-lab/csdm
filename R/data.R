#' Delury lobster data
#'
#' A dataset containing catch data for lobster from DeLury, D. B. (1947). On the
#' estimation of biological populations. Biometrics, 3, 145–167.
#'
#' @format A data frame with 33 rows and 7 variables:
#' \describe{
#'   \item{date}{Day number.}
#'   \item{catch_pounds}{Lobster catch, in pounds.}
#'   \item{traps}{Number of traps.}
#'   \item{cpue}{Catch per unit effort, such as `cpue = catch_pounds/traps`}
#'   \item{traps_cum}{Number of traps, cumulated.}
#'   \item{cpue_l}{Natural log of cpue.}
#'   \item{cpue_l10}{Log 10 of cpue.}
#' }
#' @source \url{https://www.jstor.org/stable/3001390}
"delury_lobster"
