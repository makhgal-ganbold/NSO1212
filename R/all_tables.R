#' @title Brief Information about All Tables
#'
#' @description Brief information about all available tables on the API \href{http://opendata.1212.mn/en/doc}{opendata.1212.mn} which is supported by \href{http://www.en.nso.mn}{National Statistical Office of Mongolia (NSO)}
#'
#' @param try logical: Should the body of the function be wrapped by the function \code{\link[base]{try}}? See details.
#'
#' @details The NSO server returns "HTTP error 500" frequently. Due to the server error, error handling is supported. if \code{try} is \code{TRUE}, you have to write code with error handling as shown in the example.
#'
#' @return A data frame which has brief information of all available tables if the function is executed without error, but an object of class "try-error" containing the error message, if it fails. The data frame has following structure:
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
#' all.tables <- all_tables(try = TRUE)
#' if (!inherits(all.tables, "try-error")) {
#'   print(all.tables$tbl_nm)
#'   print(all.tables$tbl_id)
#' }
#' @seealso \link{get_table}, \link{get_table_info}, \link{get_sector_info}
#' @references \url{http://opendata.1212.mn/en/doc/Api/GET-api-Itms}

all_tables <- function (try = FALSE) {

  expr = expression(jsonlite::fromJSON("http://opendata.1212.mn/api/Itms?type=json"))
  if (try) {
    return(try(expr = eval(expr), silent = TRUE))
  }
  eval(expr)

}
