#' @title Download Statistical Data from the API opendata.1212.mn
#'
#' @description It downloads a table, which contains statistical data, from the API \url{opendata.1212.mn} is supported by National Statistical Office of Mongolia (NSO).
#'
#' @param tbl_id character string, Table identification number
#' @param PERIOD charcter vector, Time
#' @param CODE charcter vector, Classification code (age, gender etc)
#' @param CODE1 charcter vector, Classification code (age, gender etc)
#' @param CODE2 charcter vector, Classification code (age, gender etc)
#'
#' @return data frame, Statistical data. It has following structure:
#' \describe{
#'  \item{TBL_ID}{Row number}
#'  \item{Period}{Time}
#'  \item{CODE}{Classification code}
#'  \item{SCR_MN}{Classification name in Mongolian}
#'  \item{SCR_ENG}{Classification name in English}
#'  \item{CODE1}{Classification code}
#'  \item{SCR_MN1}{Classification name in Mongolian}
#'  \item{SCR_ENG1}{Classification name in English}
#'  \item{CODE2}{Classification code}
#'  \item{SCR_MN2}{Classification name in Mongolian}
#'  \item{SCR_ENG2}{Classification name in English}
#'  \item{DTVAL_CO}{Data value}
#' }
#' @export
#'
#' @importFrom httr POST
#' @importFrom utils type.convert
#'
#' @examples
#' nso.data <- get_table(
#'   tbl_id = "DT_NSO_2400_015V2",
#'   PERIOD = c("201711", "201712", "201801"),
#'   CODE = c("10", "11"),
#'   CODE1 = "11"
#' )
#' print(nso.data)
#' @seealso \link{all_tables}, \link{get_table_info}, \link{get_sector_info}
#' @references \url{http://opendata.1212.mn/en/doc/Api/POST-api-Data}

get_table <- function (tbl_id, PERIOD = NULL, CODE = NULL, CODE1 = NULL, CODE2 = NULL) {

  # set query

  query <- list(tbl_id = tbl_id)
  sapply(X = c("PERIOD", "CODE", "CODE1", "CODE2"), FUN = function (arg.name) {
    arg <- get(arg.name)
    if (!is.null(arg)) {
      if (!is.vector(arg, mode = "character")) {
        stop(paste0(arg.name, " is not a character vector."))
      }
      if (length(arg) == 1) {
        arg <- c(arg, "")
      }
      query[[arg.name]] <<- arg
    }
  })

  # get response

  response <- httr::POST(
    url = "http://opendata.1212.mn/api/Data?type=json",
    body = query,
    encode = "json"
  )

  # response <- httr::POST(
  #   url = "http://opendata.1212.mn/api/Data?type=json",
  #   body = paste0('{"tbl_id": "', tbl_id, '", "CODE": ["10", "11"], "CODE1": ["11"]}'),
  #   httr::content_type("application/json")
  # )

  # check HTTP status code

  if (response$status_code != 200) {
    stop(paste0("HTTP status code: ", response$status_code))
  }

  # response to list

  data.object <- jsonlite::parse_json(rawToChar(response$content))

  # Check response

  if (data.object$Response != "success") {
    stop("API Error")
  }

  # DataList to data frame

  df <- as.data.frame(do.call(
    what = rbind,
    args = lapply(
      X = data.object$DataList,
      FUN = function(x) {
        x[sapply(X = x, FUN = is.null)] <- NA # Replace NULL by NA
        unlist(x) # convert a list to a vector
      }
    )
  ))

  # attempts to coerce variables into numeric

  var.names <- names(df)
  df[var.names] <- lapply(X = df[var.names], FUN = utils::type.convert, as.is = TRUE, numerals = "no.loss")

  # return value

  return(df)

}
