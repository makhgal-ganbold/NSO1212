#' Retrieve data from the 1212.mn API v1
#'
#' Internal helper function that sends a GET request to the 1212.mn API v1
#' for a given folder and language, returning the parsed JSON response.
#'
#' @param folder Character scalar. API folder or endpoint path (default `""`).
#' @param language Character scalar. Language code, `"mn"` (default) or `"en"`.
#'
#' @return A list parsed from the JSON response.
#' @noRd
#'
#' @import httr2
#' @importFrom utils URLencode
#'
.get <- \(folder = "", language = "mn") {

  sprintf("https://data.1212.mn/api/v1/%s/NSO/%s", language, folder) |>
    utils::URLencode() |>
    httr2::request() |>
    httr2::req_timeout(seconds = 60) |>
    httr2::req_perform() ->
    response

  response |>
    httr2::resp_status() ->
    http_status_code

  if (http_status_code != 200L) {
    stop(
      sprintf("The server response status code is %s.", http_status_code),
      call. = FALSE
    )
  }

  httr2::resp_body_json(response, simplifyVector = FALSE)

}
