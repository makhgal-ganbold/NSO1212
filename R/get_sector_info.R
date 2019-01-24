#' @title Get Sector
#'
#' @description Get detailed information about all 34 sectors on \url{opendata.1212.mn}.
#'
#' @return data frame, Sector information. It has following structures:
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
#' sector_info <- get_sector_info()
#' print(sector_info)
#' @seealso \link{all_tables}, \link{get_table}, \link{get_table_info}, \link{get_subsector_info}
#' @references \url{http://opendata.1212.mn/en/doc/Api/GET-api-Sector}

get_sector_info <- function () {

  response <- httr::GET(url = "http://opendata.1212.mn/", path = "api/Sector", query = list(type = "json"))

  if (response$status_code != 200) {
    stop(paste0("HTTP status code: ", response$status_code))
  }

  jsonlite::fromJSON(rawToChar(response$content))

}
