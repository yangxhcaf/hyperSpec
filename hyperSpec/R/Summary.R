#' @title Statistical summary and other functions for `hyperSpec`.
#' @description
#' The functions
#'
#' `all`, `any`,
#'
#' `sum`, `prod`,
#'
#' `min`, `max`,
#'
#' `range`, and
#'
#' `is.na`
#'
#' for `hyperSpec` objects.
#'
#' All these functions work on the spectra matrix.
#' @name Summary
#' @docType methods
#' @rdname summary
#' @aliases Summary,hyperSpec-method Summary all,hyperSpec-method
#'   any,hyperSpec-method sum,hyperSpec-method prod,hyperSpec-method
#'   min,hyperSpec-method max,hyperSpec-method range,hyperSpec-method
#' @param x hyperSpec object
#' @param ... further objects
#' @param na.rm logical indicating whether missing values should be removed
#' @return `sum`, `prod`, `min`, `max`, and `range` return  a numeric,
#' `all`, `any`, and `is.na` a logical.
#' @seealso [base::Summary()] for the base summary functions.
#'
#' @export
#'
#' @concept stats
#'
#' @examples
#'
#' range(flu)
setMethod(
  "Summary", signature(x = "hyperSpec"),
  function(x, ..., na.rm = FALSE) {
    validObject(x)

    if ((.Generic == "prod") || (.Generic == "sum")) {
      warning(paste("Do you really want to use", .Generic, "on a hyperSpec object?"))
    }

    ## dispatch also on the objects in ...
    x <- sapply(list(x[[]], ...), .Generic, na.rm = na.rm)

    callGeneric(x, na.rm = na.rm)
  }
)

#' @rdname summary
#' @aliases is.na,hyperSpec-method
#' @seealso [base::all.equal()] and [base::isTRUE()]
#' @export
#' @examples
#'
#' is.na(flu [, , 405 ~ 410])
setMethod(
  "is.na", signature(x = "hyperSpec"),
  function(x) {
    is.na(x@data$spc)
  }
)

#' @details
#' `all_wl` and `any_wl` are shortcut function to check whether
#' any or all intensities fulfill the condition per spectrum.
#' `na.rm` behaviour is like [base::all()] and [base::any()].
#'
#' @param expression expression that evaluates to a logical matrix of the same size as the spectra matrix
#'
#' @rdname summary
#' @export
#' @examples
#'
#' all_wl(flu > 100)
all_wl <- function(expression, na.rm = FALSE) {
  res <- rowSums(!expression, na.rm = TRUE) == 0

  if (!na.rm) {
    res[res] <- rowSums(expression[res, , drop = FALSE], na.rm = FALSE) == ncol(expression)
  }

  res
}

# Unit tests -----------------------------------------------------------------

hySpc.testthat::test(all_wl) <- function() {
  context("all_wl")

  test_that(
    "checking minimum intensity",
    expect_equal(
      all_wl(flu > 100),
      apply(flu > 100, 1, all)
    )
  )

  test_that("na.rm behaviour of base::all", {
    expect_true(is.na(all(TRUE, NA)))
    expect_true(!is.na(all(FALSE, NA)))

    expect_true(all(TRUE, NA, na.rm = TRUE))
  })

  test_that("na.rm", {
    tmp <- flu
    tmp[[3:4, , 450 ~ 460]] <- NA

    expect_equal(
      all_wl(tmp > 100),
      apply(tmp > 100, 1, all)
    )
    expect_equal(
      all_wl(tmp > 100, na.rm = TRUE),
      apply(tmp > 100, 1, all, na.rm = TRUE)
    )
    expect_equal(
      all_wl(tmp > 100, na.rm = FALSE),
      apply(tmp > 100, 1, all, na.rm = FALSE)
    )
  })
}

# ... ------------------------------------------------------------------------

#' @rdname summary
#' @export
#' @examples
#'
#' any_wl(flu > 300)
#' !any_wl(is.na(flu))
any_wl <- function(expression, na.rm = FALSE) {
  res <- rowSums(expression, na.rm = TRUE) > 0

  if (!na.rm) {
    res[!res] <- !rowSums(expression[!res, , drop = FALSE], na.rm = FALSE) == 0
  }

  res
}


# Unit tests -----------------------------------------------------------------
hySpc.testthat::test(any_wl) <- function() {
  context("any_wl")

  test_that(
    "checking maximum intensity",
    expect_equal(
      any_wl(flu > 400),
      apply(flu > 400, 1, any)
    )
  )

  test_that("na.rm behaviour of base::any", {
    expect_true(!is.na(any(TRUE, NA)))
    expect_true(is.na(any(FALSE, NA)))

    expect_true(!any(FALSE, NA, na.rm = TRUE))
  })

  test_that("na.rm", {
    tmp <- flu
    tmp[[3:4, , 450 ~ 460]] <- NA

    expect_equal(
      any_wl(tmp > 400),
      apply(tmp > 400, 1, any)
    )
    expect_equal(
      any_wl(tmp > 400, na.rm = TRUE),
      apply(tmp > 400, 1, any, na.rm = TRUE)
    )
    expect_equal(
      any_wl(tmp > 400, na.rm = FALSE),
      apply(tmp > 400, 1, any, na.rm = FALSE)
    )
  })

  test_that("Summary warnings", {
    expect_warning(
      prod(flu),
      "Do you really want to use prod on a hyperSpec object?"
    )

    expect_warning(
      sum(flu),
      "Do you really want to use sum on a hyperSpec object?"
    )

  })
}
