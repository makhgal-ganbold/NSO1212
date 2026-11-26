#' Retrieve table IDs, names, and update metadata for a subsector
#'
#' Validates that `subsector_id` belongs to `sector_id`, fetches the list of
#' tables from the 1212.mn API v1, and returns it as a `data.frame`.
#'
#' @param sector_id Character scalar. Identifier of the parent sector.
#' @param subsector_id Character scalar. Identifier of the subsector belonging
#'   to `sector_id`.
#' @param language Character scalar. Language code, `"mn"` or `"en"`.
#'   Any other non-empty character value defaults to `"mn"` (default `"mn"`).
#'
#' @return A `data.frame` containing table metadata for the given subsector.
#' @export
#'
#' @examples
#' tables <- nso_tables(
#'   sector_id = "Population, household",
#'   subsector_id = "1_Population, household",
#'   language = "en"
#' )
#' print(tables)
#'
#' @seealso \link{nso_subsectors}, \link{nso_table}
#'
#' @references \url{https://www.1212.mn/en/data-base/open-data}
#'
nso_tables <- \(sector_id, subsector_id, language = "mn") {

  subsector_id |>
    .validate_id(id_name = "subsector_id") ->
    subsector_id

  available_subsectors <- nso_subsectors(sector_id = sector_id, language = language)
  if ("id" %notin% names(available_subsectors)) {
    stop("Subsector ids are missing in the API response.", call. = FALSE)
  }
  if (subsector_id %notin% available_subsectors$id) {
    stop("The subsector mismatches the sector.", call. = FALSE)
  }

  paste(sector_id, subsector_id, sep = "/") |>
    .get(language = language) |>
    .as_df()

}
