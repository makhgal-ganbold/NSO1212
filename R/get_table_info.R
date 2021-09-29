#' @title Detailed Information about a Database Table and Its Classification
#'
#' @description Detailed information about a database table and its classification on the open-data API which is supported by National Statistical Office of Mongolia (NSO)
#'
#' @param tbl_id character string, Table identification number
#' @param simplify logical: Should the result be simplified to a vector and a data frame?
#' @param try logical: Should the body of the function be wrapped by the function \code{\link[base]{try}}? See details.
#' @param timeout positive numeric or \code{Inf}: The number of seconds to wait for a response from the NSO server. Can not be less than 1 ms or 0.001 s.
#'
#' @details The NSO server returns "HTTP error 500" frequently. Due to the server error, error handling is supported. if \code{try} is \code{TRUE}, you have to write code with error handling as shown in the example.
#'
#' @return A list which contains information about database table and its classification if the function is executed without error, but an object of class "try-error" containing the error message, if it fails. The list has following structure:
#' \describe{
#'  \item{tbl_id}{Table identification number}
#'  \item{unit_id}{Unit identification number}
#'  \item{unit_nm}{Unit name in Mongolia}
#'  \item{unit_eng_nm}{Unit name in English}
#'  \item{obj}{Table classification:
#'   \describe{
#'    \item{obj_var_id}{Variable identification}
#'    \item{var_ord_sn}{Variable identification number}
#'    \item{field}{Field name}
#'    \item{scr_mn}{Variable name in Mongolian}
#'    \item{scr_eng}{Variable identification}
#'    \item{itm}{Variable classification and code:
#'     \describe{
#'      \item{itm_id}{Classification number}
#'      \item{up_itm_id}{Sub-classification}
#'      \item{scr_mn}{Classification name in Mongolian}
#'      \item{scr_eng}{Classification name in English}
#'     }
#'    }
#'   }
#'  }
#' }
#' if \code{simplify} is \code{TRUE}, an user-friendly result is returned.
#' @export
#'
#' @importFrom httr GET
#' @importFrom jsonlite parse_json
#'
#' @examples
#' # tree shaped result
#' table_info <- get_table_info("DT_NSO_2400_015V2", try = TRUE,, timeout = 4)
#' if (!inherits(table_info, "try-error")) {
#'   str(table_info)
#' }
#' # tabular result
#' table_info_simplified <- get_table_info(
#'   "DT_NSO_2400_015V2", simplify = TRUE, try = TRUE, timeout = 4)
#' if (!inherits(table_info_simplified, "try-error")) {
#'   str(table_info_simplified)
#' }
#' @seealso \link{all_tables}, \link{get_table}, \link{get_sector_info}
#' @references \url{http://opendata.1212.mn/en/doc/Api/GET-api-Itms-id}

get_table_info <- function (tbl_id, simplify = FALSE, try = FALSE, timeout = Inf) {

  expr = expression({
    url <- "http://opendata.1212.mn/"
    path <- paste0("api/Itms/", tbl_id)
    query <- list(type = "json")
    if (is.infinite(timeout)) {
      response <- httr::GET(url = url, path = path, query = query)
    } else {
      response <- httr::GET(url = url, path = path, query = query, httr::timeout(timeout))
    }
    if (response$status_code != 200) {
      stop(paste0("HTTP status code: ", response$status_code))
    }
    table_info <- jsonlite::parse_json(httr::content(response, as = "text", type = "application/json", encoding = "UTF-8"))
    if (simplify) {
      table_info <- c(table_info["tbl_id"], prepare.unit_info(table_info), prepare.code_info(table_info), prepare.codes(table_info))
    }
    table_info
  })
  if (try) {
    return(try(expr = eval(expr), silent = TRUE))
  }
  eval(expr)

}

#' @noRd

prepare.unit_info <- function (table_info) {

   list(unit = unlist(table_info[c("unit_id", "unit_nm", "unit_eng_nm")]))

}

#' @noRd

prepare.code_info <- function (table_info) {

  list(codes = as.data.frame(t(sapply(X = table_info$obj, FUN = function (obj) {
    unlist(obj[c("field", "scr_mn", "scr_eng", "obj_var_id", "var_ord_sn")])
  })), stringsAsFactors = FALSE))

}

#' @noRd

prepare.codes <- function (table_info) {
  codes <- list()
  n.code <- length(table_info$obj)
  if (n.code > 3) {
    warning("An unsupported CODE was detected from the table info. Please contact the package maintainer.")
    n.code <- 3
  }
  if (n.code > 0) {
    for (i in 1:n.code) {
      item_ids <- NULL
      scr_mns <- NULL
      scr_ens <- NULL
      for (itm in table_info$obj[[i]]$itm) {
        item_ids[""] <- itm$itm_id
        scr_mns[""] <- itm$scr_mn
        scr_ens[""] <- itm$scr_eng
      }
      itm <- data.frame(scr_mns, scr_ens, item_ids, stringsAsFactors = FALSE)
      if (i == 1) {
        codes$CODE <- itm
      } else if (i == 2) {
        codes$CODE1 <- itm
      } else {
        codes$CODE2 <- itm
      }
    }
  }
  codes
}
