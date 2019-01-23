
#' @title All Tables
#'
#' @description Get list of all available tables on \url{opendata.1212.mn}.
#'
#' @return data.frame, a list of all available tables
#' @export
#'
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' all.tables <- all_tables()
#' print(all.tables$tbl_nm)
#' print(all.tables$tbl_id)
#' @seealso \link{statistical_data}

all_tables <- function () {

  jsonlite::fromJSON("http://opendata.1212.mn/api/Itms?type=json")

}

#' @title Get statistical data
#'
#' @description Get statistical data from \url{opendata.1212.mn}.
#'
#' @param tbl_id character string, Table identification number
#' @param PERIOD charcter vector, Time
#' @param CODE charcter vector, Classification code (age, gender etc)
#' @param CODE1 charcter vector, Classification code (age, gender etc)
#' @param CODE2 charcter vector, Classification code (age, gender etc)
#'
#' @return data frame, Statistical data
#' @export
#'
#' @importFrom httr POST
#' @importFrom utils type.convert
#'
#' @examples
#' statistical.data <- statistical_data(
#'   tbl_id = "DT_NSO_2400_015V2",
#'   PERIOD = c("201711", "201712", "201801"),
#'   CODE = c("10", "11"),
#'   CODE1 = "11"
#' )
#' print(statistical.data)
#' @seealso \link{all_tables}

statistical_data <- function (tbl_id, PERIOD = NULL, CODE = NULL, CODE1 = NULL, CODE2 = NULL) {

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
