# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.math2 <-  function(x, digits) {
  validObject(x)

  x[[]] <- callGeneric(x[[]], digits)

  x
}

#' Mathematical Functions for `hyperSpec` Objects.
#'
#' The functions `abs()`, `sign()`, `sqrt()`, `floor()`, `ceiling()`, `trunc()`,
#' `round()`, `signif()`, `exp()`, `log()`, `expm1()`, `log1p()`, `cos()`,
#' `sin()`, `tan()`, `acos()`, `asin()`, `atan()`, `cosh()`, `sinh()`, `tanh()`,
#' `acosh()`, `asinh`, `atanh()`, `lgamma()`, `gamma()`, `digamma()`,
#' `trigamma()`, `cumsum()`, `cumprod()`, `cummax()`, `cummin()` for `hyperSpec`
#'  objects.
#'
#' @aliases  Math Math2 Math,hyperSpec-method Math2,hyperSpec-method abs,hyperSpec-method
#' sign,hyperSpec-method sqrt,hyperSpec-method floor,hyperSpec-method ceiling,hyperSpec-method
#' trunc,hyperSpec-method round,hyperSpec-method signif,hyperSpec-method exp,hyperSpec-method
#' log,hyperSpec-method expm1,hyperSpec-method log1p,hyperSpec-method cos,hyperSpec-method
#' sin,hyperSpec-method tan,hyperSpec-method acos,hyperSpec-method asin,hyperSpec-method
#' atan,hyperSpec-method cosh,hyperSpec-method sinh,hyperSpec-method tanh,hyperSpec-method
#' acosh,hyperSpec-method asinh,hyperSpec-method atanh,hyperSpec-method lgamma,hyperSpec-method
#' gamma,hyperSpec-method digamma,hyperSpec-method trigamma,hyperSpec-method cumsum,hyperSpec-method
#' cumprod,hyperSpec-method cummax,hyperSpec-method cummin,hyperSpec-method round,hyperSpec-method
#' signif,hyperSpec-method
#' @param x the `hyperSpec` object
#' @param digits integer stating the rounding precision
#' @return a `hyperSpec` object
#' @rdname math
#' @author C. Beleites
#' @seealso [methods::S4groupGeneric()] for group generic methods.
#'
#' [base::Math()] for the base math functions.
#'
#' [hyperSpec::Arith()] for arithmetic operators,
#' [hyperSpec::Comparison()] for comparison operators, and
#' [hyperSpec::Summary()] for group generic functions working on `hyperSpec`
#' objects.
#'
#' @keywords methods math
#' @export
#'
#' @concept manipulation
#'
#' @examples
#'
#' log(flu)
setMethod(
  "Math2", signature(x = "hyperSpec"), .math2)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.log <- function(x, base = exp(1), ...) {
  validObject(x)

  x[[]] <- log(x[[]], base = base)
  x
}

#' @rdname math
#' @param ... ignored
#' @param base base of logarithm
#' @export
#'
#' @concept manipulation
#'
#' @aliases log log,hyperSpec-method
setMethod("log", signature(x = "hyperSpec"), .log)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.math <- function(x) {
  validObject(x)

  if (grepl("^cum", .Generic) || grepl("gamma$", .Generic)) {
    warning(paste("Do you really want to use", .Generic, "on a hyperSpec object?"))
  }

  x[[]] <- callGeneric(x[[]])
  x
}


#' @rdname math
#' @export
#'
#' @concept manipulation
#'
setMethod("Math", signature(x = "hyperSpec"), .math)


# Unit tests -----------------------------------------------------------------
hySpc.testthat::test(.math) <- function() {

  context("math")

  # Perform tests
  test_that("math warnings work", {
    expect_warning(cumsum(flu), "Do you really want to use")
  })

  test_that("math works", {
    expect_silent(flu + flu)
    expect_silent(flu ^ flu)

    expect_silent(abs(flu))
    expect_silent(sqrt(flu))
    expect_silent(round(flu, 2))
    expect_silent(max(flu))
  })

  test_that("log() works", {
    expect_silent(log(flu))
  })

  test_that("comparison works", {
    expect_silent(flu == flu)
    expect_silent(flu >= flu | flu > flu)
    expect_silent(all(flu == flu[[]]))
    expect_silent(all(flu[[]] == flu))
    expect_silent(flu[, , 445 ~ 450] > 300)
  })
}
