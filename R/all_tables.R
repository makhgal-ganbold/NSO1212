#' @title Brief Information about All Database Tables
#'
#' @description Brief information about all available database tables on the open-data API which is supported by National Statistical Office of Mongolia (NSO)
#'
#' @param try logical: Should the body of the function be wrapped by the function \code{\link[base]{try}}? See details.
#' @param timeout positive numeric or \code{Inf}: The number of seconds to wait for a response from the NSO server. Can not be less than 1 ms or 0.001 s.
#' @param na.rm logical: If \code{TRUE}, it removes empty rows in a data frame which is result of this function.
#'
#' @details The NSO server returns "HTTP error 500" frequently. Due to the server error, error handling is supported. if \code{try} is \code{TRUE}, you have to write code with error handling as shown in the example.
#'
#' @return A data frame which has brief information of all available database tables if the function is executed without error, but an object of class "try-error" containing the error message, if it fails. The data frame has following structure:
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
#' all.tables <- all_tables(try = TRUE, timeout = 4)
#' if (!inherits(all.tables, "try-error")) {
#'   str(all.tables)
#' }
#' @seealso \link{get_table}, \link{get_table_info}, \link{get_sector_info}
#' @references \url{http://opendata.1212.mn/en/doc/Api/GET-api-Itms}

all_tables <- function (try = FALSE, timeout = Inf, na.rm = FALSE) {

  expr <- expression({
    url <- "http://opendata.1212.mn/"
    path <- "api/Itms"
    query <- list(type = "json")
    if (is.infinite(timeout)) {
      response <- httr::GET(url = url, path = path, query = query)
    } else {
      response <- httr::GET(url = url, path = path, query = query, httr::timeout(timeout))
    }
    if (response$status_code != 200) {
      stop(paste0("HTTP status code: ", response$status_code))
    }
    all.tables <- jsonlite::fromJSON(httr::content(response, as = "text", type = "application/json", encoding = "UTF-8"))
    if (na.rm) {
      all.tables <- stats::na.omit(all.tables)
    }
    all.tables
  })
  if (try) {
    return(try(expr = eval(expr), silent = TRUE))
  }
  eval(expr)

}
