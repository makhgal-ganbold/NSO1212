#' Retrieve sector IDs and names from the 1212.mn API v1
#'
#' Fetches top-level sector information from the 1212.mn API v1 and returns
#' it as a `data.frame`.
#'
#' @param language Character scalar. Language code, `"mn"` or `"en"`.
#'   Any other non-empty character value defaults to `"mn"` (default `"mn"`).
#'
#' @return A `data.frame` containing sector metadata from the API.
#' @export
#'
#' @examples
#' \donttest{
#' sectors <- nso_sectors(language = "en")
#' print(sectors)
#' }
#'
#' @seealso \link{nso_subsectors}
#'
#' @references \url{https://www.1212.mn/en/data-base/open-data}
#'
nso_sectors <- \(language = "mn") {

  language |>
    .validate_language() ->
    language

  .get(folder = "", language = language) |>
    .as_df()

}
