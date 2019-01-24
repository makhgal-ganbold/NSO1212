#' @title Detailed Information about a Sub-Sector on the API opendata.1212.mn
#'
#' @description Detailed information about a sub-sector, which is minor classification of data, on the API \url{opendata.1212.mn} is supported by National Statistical Office of Mongolia (NSO)
#'
#' @param subid character string, Sub-sector identification number
#'
#' @return data frame, Sub-sector information. It has following structure:
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
#' subsector_info <- get_subsector_info("976_L05")
#' print(subsector_info)
#' @seealso \link{all_tables}, \link{get_table}, \link{get_table_info}, \link{get_sector_info}
#' @references \url{http://opendata.1212.mn/en/doc/Api/GET-api-Sector_subid}

get_subsector_info <- function (subid) {

  response <- httr::GET(url = "http://opendata.1212.mn/", path = "api/Sector", query = list(subid = subid, type = "json"))

  if (response$status_code != 200) {
    stop(paste0("HTTP status code: ", response$status_code))
  }

  jsonlite::fromJSON(rawToChar(response$content))

}
