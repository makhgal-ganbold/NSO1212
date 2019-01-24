#' @title Table Information and Classification
#'
#' @description Get detailed information about a table on \url{opendata.1212.mn}.
#'
#' @param tbl_id character string, Table identification number
#'
#' @return list, Table information and classification. It has following structures:
#' \itemize{
#'  \item{tbl_id -}{ Table identification number}
#'  \item{unit_id -}{ Unit Identification number}
#'  \item{unit_nm -}{ Unit Name /Mongolia/}
#'  \item{unit_eng_nm -}{ Unit Name /English/}
#'  \item{obj -}{ Table classification:
#'   \itemize{
#'    \item{obj_var_id -}{ Variable identification}
#'    \item{var_ord_sn -}{ Variable identification number}
#'    \item{field -}{ Field name}
#'    \item{scr_mn -}{ Variable name /Mongolia/}
#'    \item{scr_eng -}{ Variable identification}
#'    \item{itm -}{ Variable classification and code:
#'     \itemize{
#'      \item{itm_id -}{ Classification Number}
#'      \item{up_itm_id -}{ Sub classification}
#'      \item{scr_mn -}{ Classification name /Mongolia/}
#'      \item{scr_eng -}{ Classification name /English/}
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
