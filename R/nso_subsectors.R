#' Retrieve subsector IDs and names for a specific sector from the 1212.mn API v1
#'
#' Validates `sector_id` against available top-level sectors, fetches subsector
#' information from the 1212.mn API v1, and returns it as a `data.frame`.
#'
#' @param sector_id Character scalar. Identifier of the parent sector.
#' @param language Character scalar. Language code, `"mn"` or `"en"`.
#'   Any other non-empty character value defaults to `"mn"` (default `"mn"`).
#'
#' @return A `data.frame` containing subsector data for the given sector.
#' @export
#'
#' @examples
#' subsectors <- nso_subsectors(
#'   sector_id = "Population, household",
#'   language = "en"
#' )
#' print(subsectors)
#'
#' @seealso \link{nso_sectors}, \link{nso_tables}
#'
#' @references \url{https://www.1212.mn/en/data-base/open-data}
#'
nso_subsectors <- \(sector_id, language = "mn") {

  sector_id |>
    .validate_id(id_name = "sector_id") ->
    sector_id

  available_sectors <- nso_sectors(language = language)
  if ("id" %notin% names(available_sectors)) {
    stop("Sector ids are missing in the API response.", call. = FALSE)
  }
  if (sector_id %notin% available_sectors$id) {
    stop("The sector id is not valid.", call. = FALSE)
  }

  sector_id |>
    .get(language = language) |>
    .as_df()

}
