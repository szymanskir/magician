#' Retries the passed expression the specified amount
#' of attempts. Between each retry it sleeps for a specified amount
#' of time.
#'
#' @param expr expression to retry
#'
#' @param retry_time time to sleep between attempts
#'
#' @param retry_count number of attempts to run the expression
#'
#'
#' @return result of the passed expression
#'
#' @noRd
#'
retry <- function(expr, retry_time, retry_count) {
  expr_succeeded <- FALSE

  for (retry_ind in seq_len(retry_count)) {
    tryCatch(
      expr = {
        # suppress restarting interrupted promise evaluation
        result <- suppressWarnings(eval(expr))
        expr_succeeded <- TRUE
      },
      error = function(e) {
        sleep(retry_time)
      }
    )
  }

  if (expr_succeeded) {
    result
  } else {
    stop(paste0("Expression failed after ", retry_count, " tries."))
  }
}


#' Wrapper around Sys.sleep
#'
#' @noRd
#'
sleep <- function(time) {
  Sys.sleep(time)
}


#' Throws an error if the passed package is not available
#'
#' @param package name of the package to check if it is available
#'
#'
require_package <- function(package) {
  if (!requireNamespace(package, quietly = TRUE)) {
    stop(sprintf("Package %s has to be installed to use this function", package))
  }
}
