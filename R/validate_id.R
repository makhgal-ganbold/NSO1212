#' Validate and normalize an identifier argument
#'
#' Internal helper function that validates a scalar identifier string, trims
#'   surrounding whitespace, rejects `NA` or empty values, and returns
#'   a normalized `character` scalar.
#'
#' @param id An identifier scalar value to validate.
#' @param id_name Character scalar naming the argument being validated, used
#'   in error messages.
#'
#' @return A trimmed, non-empty `character` scalar.
#' @noRd
#'
.validate_id <- \(id, id_name) {

  if (
    !is.character(id_name) ||
    length(id_name) != 1L ||
    is.na(id_name) ||
    !nzchar(trimws(id_name))
  ) {
    stop(
      "`id_name` must be a non-empty character scalar.",
      call. = FALSE
    )
  }

  if (
    !is.character(id) ||
    length(id) != 1L ||
    is.na(id)
  ) {
    stop(
      sprintf("`%s` must be a non-NA scalar value.", id_name),
      call. = FALSE
    )
  }

  id |>
    trimws() ->
    id
  if (!nzchar(id)) {
    stop(
      sprintf("`%s` must not be empty.", id_name),
      call. = FALSE
    )
  }

  id

}
