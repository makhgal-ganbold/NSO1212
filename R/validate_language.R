#' Validate and normalize a language code argument
#'
#' Internal helper function that validates a scalar character language code,
#' trims whitespace, converts it to lowercase, and defaults any code other
#' than `"mn"` or `"en"` to `"mn"`.
#'
#' @param language Character scalar. Language code to validate (default `"mn"`).
#'
#' @return A normalized `character` scalar, either `"mn"` or `"en"`.
#' @noRd
#'
.validate_language <- \(language = "mn") {

  if (
    !is.character(language) ||
    length(language) != 1L ||
    is.na(language)
  ) {
    stop(
      "`language` must be a non-NA character scalar.",
      call. = FALSE
    )
  }

  language |>
    trimws() |>
    tolower() ->
    language

  if (language %notin% c("mn", "en")) {
    language <- "mn"
  }

  language

}
