#' @title Brief Information about All Tables on the API opendata.1212.mn
#'
#' @description Brief information about all available tables on the API \url{opendata.1212.mn} is supported by National Statistical Office of Mongolia (NSO)
#'
#' @return data.frame, a list of all available tables. It has following structure:
#' \describe{
#'  \item{rownum}{Row number}
#'  \item{list_id}{Sector number}
#'  \item{tbl_id}{Table identification number}
#'  \item{tbl_nm}{Table name in Mongolian}
#'  \item{tbl_eng_nm}{Table name in English}
#'  \item{unit_id}{Unit code}
#'  \item{cd_nm}{Unit name in Mongolian}
#'  \item{cd_eng_nm}{Unit name in English}
#'  \item{strt_prd}{Start date}
#'  \item{end_prd}{Finish date}
#'  \item{prd_se}{Time frequency}
#'  \item{lst_chn_de}{Last update date}
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
