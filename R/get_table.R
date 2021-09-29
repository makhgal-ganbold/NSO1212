#' @title Download a Database Table
#'
#' @description It downloads a database table, which contains statistical data, from the open-data API which is supported by National Statistical Office of Mongolia (NSO).
#'
#' @param tbl_id character string, Table identification number
#' @param PERIOD character vector, Time
#' @param CODE,CODE1,CODE2 character vector, Classification code (age, gender etc)
#' @param try logical: Should the main body of the function be wrapped by the function \code{\link[base]{try}}? See details.
#' @param timeout positive numeric or \code{Inf}: The number of seconds to wait for a response from the NSO server. Can not be less than 1 ms or 0.001 s.
#'
#' @details The NSO server returns "HTTP error 500" frequently. Due to the server error, error handling is supported. if \code{try} is \code{TRUE}, you have to write code with error handling as shown in the example.
#'
#' @return A data frame if the function is executed without error, but an object of class "try-error" containing the error message, if it fails. The data frame has following structure:
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
#'  \item{DTVAL_CO}{Datum}
#' }
#' @export
#'
#' @importFrom httr POST
#' @importFrom utils type.convert
#'
#' @examples
#' nso.data <- get_table(
#'   tbl_id = "DT_NSO_2400_015V2",
#'   PERIOD = make_period(start = "201711", end = "202103", period = "M"),
#'   CODE = c("10", "11"),
#'   CODE1 = "11",
#'   try = TRUE,  # to prevent a server error
#'   timeout = 4
#' )
#' if (!inherits(nso.data, "try-error")) {
#'   print(nso.data)
#' }
#' @seealso \link{all_tables}, \link{get_table_info}, \link{get_sector_info}
#' @references \url{http://opendata.1212.mn/en/doc/Api/POST-api-Data}

get_table <- function (tbl_id, PERIOD = NULL, CODE = NULL, CODE1 = NULL, CODE2 = NULL, try = FALSE, timeout = Inf) {

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

  expr = expression({

    # get response

    url <- "http://opendata.1212.mn/api/Data?type=json"
    encode = "json"
    if (is.infinite(timeout)) {
      response <- httr::POST(url = url, body = query, encode = encode)
    } else {
      response <- httr::POST(url = url, body = query, encode = encode, httr::timeout(timeout))
    }

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

    data.object <- jsonlite::parse_json(httr::content(response, as = "text", type = "application/json", encoding = "UTF-8"))

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

    # result

    df

  })
  if (try) {
    return(try(expr = eval(expr), silent = TRUE))
  }
  eval(expr)

}

#' @describeIn get_table It is used to prepare values for the argument \code{PERIOD} of the function \link{get_table}.
#' @param start,end Starting and stopping moments of period which has following formats: "YYYY", "YYYYMM", "YYYYMMDD", "YYYYQQ". Notations YYYY, MM, DD and QQ, respectively, indicate year, month, day and quarter of a date. These are written as a number has a leading zero, if necessary.
#' @param period One of single characters "Y" (default), "M", "D" and "Q" which represent periods yearly, monthly, daily and quarterly respectively. There is one more value "F" which is supported by the API. However it can not be used for such function due to there is not a fixed rule for this type of periods.
#'
#' @return a character vector which contains an API compatible period.
#'
#' @export

make_period <- function (start, end = NULL, period = "Y") {
  if (is.null(end)) {
    date <- Sys.Date()
    if (period == "Y") {
      end <- format(date, "%Y")
    } else if (period == "M") {
      end <- format(date, "%Y%m")
    } else if (period == "D") {
      end <- format(date, "%Y%m%d")
    } else if (period == "Q") {
      end <- paste0(format(date, "%Y"), sub(pattern = "Q", replacement = "0", x = quarters(date), fixed = TRUE))
    }
  }
  if (period == "Y") {
    start <- as.integer(substr(x = start, start = 1, stop = 4))
    end <- as.integer(substr(x = end, start = 1, stop = 4))
    return(as.character(start:end))
  } else if (period == "M") {
    start <- paste0(substr(x = start, start = 1, stop = 6), "15")
    end <- paste0(substr(x = end, start = 1, stop = 6), "15")
    return(format(seq(from = as.Date(start, format = "%Y%m%d"), as.Date(end, format = "%Y%m%d"), by = "months"), format = "%Y%m"))
  } else if (period == "D") {
    return(format(seq(from = strptime(start, format = "%Y%m%d"), strptime(end, format = "%Y%m%d"), by = "days"), format = "%Y%m%d"))
  } else if (period == "Q") {
    start <- paste0(substr(x = start, start = 1, stop = 4), sprintf("%02d", as.integer(substr(x = start, start = 5, stop = 6)) * 3), 15)
    end <- paste0(substr(x = end, start = 1, stop = 4), sprintf("%02d", as.integer(substr(x = end, start = 5, stop = 6)) * 3), 15)
    quarters <- format(seq(from = as.Date(start, format = "%Y%m%d"), as.Date(end, format = "%Y%m%d"), by = "quarters"), format = "%Y%m")
    return(paste0(substr(x = quarters, start = 1, stop = 4), sprintf("%02d", as.integer(substr(x = quarters, start = 5, stop = 6)) / 3)))
  } else {
    stop("The argument period is invalid.")
  }
}
