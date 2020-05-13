#' @title Detailed Information about a Sub-Sector
#'
#' @description Detailed information about a sub-sector, which is minor classification of data, on the API \href{http://opendata.1212.mn/en/doc}{opendata.1212.mn} which is supported by \href{http://www.en.nso.mn}{National Statistical Office of Mongolia (NSO)}
#'
#' @param subid character string, Sub-sector identification number
#' @param try logical: Should the body of the function be wrapped by the function \code{\link[base]{try}}? See details.
#'
#' @details The NSO server returns "HTTP error 500" frequently. Due to the server error, error handling is supported. if \code{try} is \code{TRUE}, you have to write code with error handling as shown in the example.
#'
#' @return A data frame which has sub-sector information if the function is executed without error, but an object of class "try-error" containing the error message, if it fails. The data frame has following structure:
#' \describe{
#'  \item{rownum}{Row number}
#'  \item{list_id}{Sector identification number}
#'  \item{up_list_id}{Sub sector identification number}
#'  \item{list_nm}{Sector name in Mongolian}
#'  \item{list_eng_nm}{Sector name in English}
#'  \item{isExist}{Whether or exist sub-sectors}
#' }
#' @export
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' subsector_info <- get_subsector_info("976_L05", try = TRUE)
#' if (!inherits(subsector_info, "try-error")) {
#'   print(subsector_info)
#' }
#' @seealso \link{all_tables}, \link{get_table}, \link{get_table_info}, \link{get_sector_info}
#' @references \url{http://opendata.1212.mn/en/doc/Api/GET-api-Sector_subid}

get_subsector_info <- function (subid, try = FALSE) {

  expr = expression({
    response <- httr::GET(url = "http://opendata.1212.mn/", path = "api/Sector", query = list(subid = subid, type = "json"))
    if (response$status_code != 200) {
      stop(paste0("HTTP status code: ", response$status_code))
    }
    jsonlite::fromJSON(rawToChar(response$content))
  })
  if (try) {
    return(try(expr = eval(expr), silent = TRUE))
  }
  eval(expr)

}
