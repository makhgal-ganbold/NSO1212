#' @title Get Subsector
#'
#' @description Get detailed information about subsectors on \url{opendata.1212.mn}.
#'
#' @param subid character string, Sub sector identification number
#'
#' @return data frame, Subsector information. It has following structures:
#' \enumerate{
#'  \item{rownum -}{ Row number}
#'  \item{list_id -}{ Sector identification number}
#'  \item{up_list_id -}{ Sub sector identification number}
#'  \item{list_nm -}{ Sector name /Mongolia/}
#'  \item{list_eng_nm -}{ Sector name /English/}
#'  \item{isExist -}{ Exist sub sector}
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
