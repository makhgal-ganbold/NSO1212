#' @title Detailed Information about All Main Sectors
#'
#' @description Detailed information about all main sectors are the main classification of data on the open-data API, which is supported by the National Statistical Office of Mongolia (NSO)
#'
#' @param try logical: Should the body of the function be wrapped by the function \code{\link[base]{try}}? See details.
#' @param timeout positive numeric or \code{Inf}: The number of seconds to wait for a response from the NSO server. You can not set it to less than 1 ms or 0.001 s.
#'
#' @details The NSO server returns "HTTP error 500" frequently. Due to the server error, error handling is supported. If \code{try} is \code{TRUE}, you have to write code with error handling, as shown in the example.
#'
#' @return If the function is executed without error, it returns a data frame that includes sector information. Otherwise, it returns an object of class "try-error" containing the error message. The data frame has the following structure:
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
#' sector_info <- get_sector_info(try = TRUE, timeout = 4)
#' if (!inherits(sector_info, "try-error")) {
#'   print(sector_info)
#' }
#' @seealso \link{all_tables}, \link{get_table}, \link{get_table_info}, \link{get_subsector_info}
#' @references \url{http://opendata.1212.mn/en/doc/Api/GET-api-Sector}

get_sector_info <- function (try = FALSE, timeout = Inf) {

  expr = expression({
    url <- "http://opendata.1212.mn/"
    path <- "api/Sector"
    query <- list(type = "json")
    if (is.infinite(timeout)) {
      response <- httr::GET(url = url, path = path, query = query)
    } else {
      response <- httr::GET(url = url, path = path, query = query, httr::timeout(timeout))
    }
    if (response$status_code != 200) {
      stop(paste0("HTTP status code: ", response$status_code))
    }
    jsonlite::fromJSON(httr::content(response, as = "text", type = "application/json", encoding = "UTF-8"))
  })
  if (try) {
    return(try(expr = eval(expr), silent = TRUE))
  }
  eval(expr)

}
