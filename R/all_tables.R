#' @title All Tables
#'
#' @description Get a list of all available tables on \url{opendata.1212.mn}.
#'
#' @return data.frame, a list of all available tables. It has following structure:
#' \enumerate{
#'  \item{rownum -}{ Row Number}
#'  \item{list_id -}{ Sector Number}
#'  \item{tbl_id -}{ Table identification number}
#'  \item{tbl_nm -}{ Table Name /Mongolia/}
#'  \item{tbl_eng_nm -}{ Table Name /English/}
#'  \item{unit_id -}{ Unit code}
#'  \item{cd_nm -}{ Unit Name /Mongolia/}
#'  \item{cd_eng_nm -}{ Unit Name /English/}
#'  \item{strt_prd -}{ Start date}
#'  \item{end_prd -}{ Finish date}
#'  \item{prd_se -}{ Time frequency}
#'  \item{lst_chn_de -}{ Last updated date}
#' }
#' @export
#'
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' all.tables <- all_tables()
#' print(all.tables$tbl_nm)
#' print(all.tables$tbl_id)
#' @seealso \link{get_table}, \link{get_table_info}, \link{get_sector_info}
#' @references \url{http://opendata.1212.mn/en/doc/Api/GET-api-Itms}

all_tables <- function () {

  jsonlite::fromJSON("http://opendata.1212.mn/api/Itms?type=json")

}
