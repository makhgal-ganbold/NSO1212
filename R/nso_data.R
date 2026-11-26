#' Retrieve statistical data from the 1212.mn API v1
#'
#' Performs a filtered data request to the 1212.mn API for a specific table,
#' validates the `query` structure and filter values against table metadata,
#' sends a POST request, and attaches a `data.frame` (`df`) to the parsed response.
#'
#' @param sector_id Character scalar. The ID of the sector containing the desired table.
#' @param subsector_id Character scalar. The ID of the subsector belonging to the given sector.
#' @param table_id Character scalar. The ID of the table within the given subsector.
#' @param query List. A JSON-stat2 query list containing `query` selections and
#'   `response = list(format = "json-stat2")`.
#' @param language Character scalar. Language of the data (`"mn"` or `"en"`).
#'   Any other value defaults to `"mn"`.
#'
#' @return A named list representing the JSON API response with an added element
#'   `df` containing the resulting `data.frame`.
#' @export
#'
#' @import httr2
#' @importFrom jsonlite fromJSON
#' @importFrom utils URLencode
#' @importFrom stats setNames
#'
#' @examples
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
#' tbl_meta$variables[[2]]
#' tbl_meta$variables[[3]]
#'
#' # query
#' '{
#' "query": [
#'   {"code": "%s", "selection": {"filter": "item", "values": ["0"]}},
#'   {"code": "%s", "selection": {"filter": "item", "values": ["0"]}},
#'   {"code": "%s", "selection": {"filter": "item", "values": ["0", "1"]}}
#' ],
#' "response": {"format": "json-stat2"}
#' }' |>
#'   sprintf( # To bypass the non-ASCII character limitation
#'     tbl_meta$variables[[1]]$code,
#'     tbl_meta$variables[[2]]$code,
#'     tbl_meta$variables[[3]]$code
#'   ) ->
#'   query
#'
#' # download data
#' data <- nso_data(
#'   sector_id = "Population, household",
#'   subsector_id = "1_Population, household",
#'   table_id = "DT_NSO_0300_004V1.px",
#'   query = query,
#'   language = "en"
#' )
#'
#' # print downloaded data
#' print(data$df)
#'
#' @seealso \link{nso_table}
#'
#' @references \url{https://www.1212.mn/en/data-base/open-data}
#'
nso_data <- \(sector_id, subsector_id, table_id, query, language = "mn") {

  nso_table(sector_id, subsector_id, table_id) ->
    tbl_meta

  tryCatch(
    {
      query |>
        jsonlite::fromJSON(simplifyVector = FALSE) ->
        query

      expected_response <- list(format = "json-stat2")
      if (is.null(query$response) || !identical(query$response, expected_response)) {
        stop(
          'The response parameter in the query is not equal to {"format": "json-stat2"}.',
          call. = FALSE
        )
      }

      if (is.null(query$query) || !is.list(query$query)) {
        stop(
          'The "query" parameter must be a list of filter definitions.',
          call. = FALSE
        )
      }

      valid_codes <- stats::setNames(
        lapply(tbl_meta$variables, function(var) as.character(var$codes$values)),
        vapply(tbl_meta$variables, function(var) as.character(var$code), character(1))
      )

      for (item in query$query) {
        code_name <- item$code
        selection <- item$selection

        if (is.null(selection) || "filter" %notin% names(selection)) {
          stop(
            sprintf(
              'The "%s" code in the query parameter doesn\'t have the "filter" entry.',
              code_name
            ),
            call. = FALSE
          )
        }

        if (is.null(code_name) || code_name %notin% names(valid_codes)) {
          stop(
            sprintf(
              'The "%s" code in the query parameter contains non-existing value.',
              code_name
            ),
            call. = FALSE
          )
        }

        req_values <- as.character(selection$values)
        if (!all(req_values %in% valid_codes[[code_name]])) {
          stop(
            sprintf(
              'The "%s" code in the query parameter contains non-existing value.',
              code_name
            ),
            call. = FALSE
          )
        }
      }
    },
    error = function(e) {
      message("The query parameter is invalid ...")
      stop(e)
    }
  )

  sprintf(
    "https://data.1212.mn:443/api/v1/%s/NSO/%s/%s/%s",
    language, sector_id, subsector_id, table_id
  ) |>
    utils::URLencode() |>
    httr2::request() |>
    httr2::req_body_json(query, auto_unbox = TRUE) |>
    httr2::req_error(is_error = function(resp) FALSE) |>
    httr2::req_perform() ->
    resp

  resp |>
    httr2::resp_status() ->
    status_code
  if (status_code != 200L) {
    stop(
      sprintf("The server response status code is %d.", status_code),
      call. = FALSE
    )
  }

  resp |>
    httr2::resp_body_json(simplifyVector = FALSE) ->
    res_data

  res_data$id |>
    unlist(, use.names = FALSE) ->
    dim_ids
  stats::setNames(
    lapply(dim_ids, function(dim_id) {
      unlist(res_data$dimension[[dim_id]]$category$label, use.names = FALSE)
    }),
    vapply(dim_ids, function(dim_id) {
      as.character(res_data$dimension[[dim_id]]$label)
    }, character(1))
  ) ->
    categories

  categories |>
    rev() ->
    grid_args
  do.call(
    expand.grid,
    c(grid_args, list(stringsAsFactors = FALSE, KEEP.OUT.ATTRS = FALSE))
  ) ->
    df
  df[, rev(seq_len(ncol(df))), drop = FALSE] ->
    df
  rownames(df) <- NULL

  res_data$value |>
    unlist(use.names = FALSE) ->
    df[[if (language == "mn") "\u0425\u0443\u0432\u044c\u0441\u0430\u0433\u0447" else "Variable"]]

  res_data$df <- df
  res_data

}
