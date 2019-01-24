#' @title Detailed Information about a Table and Its Classification on the API opendata.1212.mn
#'
#' @description Detailed information about a table and its classification on the API \url{opendata.1212.mn} is supported by National Statistical Office of Mongolia (NSO)
#'
#' @param tbl_id character string, Table identification number
#'
#' @return list, Table information and classification. It has following structure:
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
#' @export
#'
#' @importFrom httr GET
#' @importFrom jsonlite parse_json
#'
#' @examples
#' table_info <- get_table_info("DT_NSO_2400_015V2")
#' table_info$unit_nm
#' table_info$obj[[1]]$itm[[1]]$scr_mn
#' @seealso \link{all_tables}, \link{get_table}, \link{get_sector_info}
#' @references \url{http://opendata.1212.mn/en/doc/Api/GET-api-Itms-id}

get_table_info <- function (tbl_id) {

  response <- httr::GET(url = "http://opendata.1212.mn/", path = paste0("api/Itms/", tbl_id), query = list(type = "json"))

  if (response$status_code != 200) {
    stop(paste0("HTTP status code: ", response$status_code))
  }

  jsonlite::parse_json(rawToChar(response$content))

}
