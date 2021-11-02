
# Print functions ---------------------------------------------------------

#' @export
print.csdm_fit <- function(x, ...){
  cat("  CSDM Model fit (temporary printing) \n")
  cat(paste0("  Data          : ", nrow(x$data),
             " rows and ", ncol(x$data), " cols \n"))
  cat(paste0("  Stan fit dims : ", paste(dim(x$fit), collapse = ", ")))
}
