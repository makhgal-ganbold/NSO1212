#' Retrieve metadata for a specific statistical table from the 1212.mn API v1
#'
#' Validates that `table_id` belongs to the specified `subsector_id` and
#' `sector_id`, fetches the table metadata from the 1212.mn API v1, and
#' converts each variable's `values` and `valueTexts` into a `codes` data
#' frame.
#'
#' @param sector_id Character or numeric scalar. Identifier of the parent sector.
#' @param subsector_id Character or numeric scalar. Identifier of the subsector
#'   belonging to `sector_id`.
#' @param table_id Character or numeric scalar. Identifier of the table within
#'   the given subsector.
#' @param language Character scalar. Language code, `"mn"` or `"en"`.
#'   Any other non-empty character value defaults to `"mn"` (default `"mn"`).
#'
#' @return A named `list` containing table metadata with structured `variables`.
#' @export
#'
#' @examples
#' \donttest{
#' # download table meta data
#' tbl_meta <- nso_table(
#'   sector_id = "Population, household",
#'   subsector_id = "1_Population, household",
#'   table_id = "DT_NSO_0300_004V1.px",
#'   language = "en"
#' )
#'
#' # table caption
#' tbl_meta$title
#'
#' # the number of codes
#' length(tbl_meta$variables)
#'
#' # code values
#' tbl_meta$variables[[1]]
#' }
#'
#' @seealso \link{nso_tables}, \link{nso_data}
#'
#' @references \url{https://www.1212.mn/en/data-base/open-data}
#'
nso_table <- \(sector_id, subsector_id, table_id, language = "mn") {

  table_id |>
    .validate_id(id_name = "table_id") ->
    table_id

  available_tables <- nso_tables(
    sector_id = sector_id,
    subsector_id = subsector_id,
    language = language
  )
  if ("id" %notin% names(available_tables)) {
    stop("Table ids are missing in the API response.", call. = FALSE)
  }
  if (table_id %notin% available_tables$id) {
    stop("The table id mismatches to the subsector.", call. = FALSE)
  }

  paste(sector_id, subsector_id, table_id, sep = "/") |>
    .get(language = language) ->
    tbl_meta

  if (!is.list(tbl_meta)) {
    stop("API response for table metadata must be a list.", call. = FALSE)
  }

  if ("variables" %in% names(tbl_meta) && is.list(tbl_meta[["variables"]])) {
    tbl_meta[["variables"]] <- lapply(
      tbl_meta[["variables"]],
      function(var_item) {
        if (!is.list(var_item)) {
          return(var_item)
        }

        has_values <- "values" %in% names(var_item)
        has_texts <- "valueTexts" %in% names(var_item)

        if (has_values && has_texts) {
          vals <- unlist(var_item[["values"]], use.names = FALSE)
          texts <- unlist(var_item[["valueTexts"]], use.names = FALSE)

          if (length(vals) != length(texts)) {
            stop(
              "Lengths of `values` and `valueTexts` do not match.",
              call. = FALSE
            )
          }

          var_item[["codes"]] <- data.frame(
            values = vals,
            valueTexts = texts,
            stringsAsFactors = FALSE
          )
          var_item[["values"]] <- NULL
          var_item[["valueTexts"]] <- NULL
        }

        var_item
      }
    )
  }

  tbl_meta

}
