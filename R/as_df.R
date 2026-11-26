#' Convert a JSON structure into a data frame
#'
#' Internal helper \ that converts parsed JSON data (typically a list of
#' named lists/records or a named list) into a base `data.frame`.
#'
#' @param json A non-empty `list` (such as a list of records or a named list)
#'   parsed from JSON.
#'
#' @return A `data.frame`.
#' @noRd
#'
#' @importFrom jsonlite toJSON
#'
.as_df <- \(json) {

  if (!is.list(json) || length(json) == 0L) {
    stop("`json` must be a non-empty list.", call. = FALSE)
  }

  is_record_list <- all(
    vapply(
      json,
      \(x) {
        is.list(x) &&
          !is.data.frame(x) &&
          length(x) > 0L &&
          !is.null(names(x)) &&
          all(nzchar(names(x)))
      },
      logical(1L)
    )
  )

  if (is_record_list) {
    all_keys <- unique(
      unlist(
        lapply(json, names),
        use.names = FALSE
      )
    )

    rows <- lapply(json, \(rec) {
      row_vals <- lapply(all_keys, \(k) {
        val <- rec[[k]]
        if (is.null(val) || length(val) == 0L) {
          return(NA)
        }
        if (length(val) > 1L) {
          return(jsonlite::toJSON(val, auto_unbox = TRUE))
        }
        val
      })
      names(row_vals) <- all_keys
      as.data.frame(row_vals, stringsAsFactors = FALSE)
    })

    out <- do.call(rbind, rows)
    rownames(out) <- NULL
    return(out)
  }

  json_names <- names(json)
  if (!is.null(json_names) && all(nzchar(json_names))) {
    normalized <- lapply(json, \(col) {
      if (is.null(col) || length(col) == 0L) {
        return(NA)
      }
      if (is.list(col)) {
        return(
          vapply(
            col,
            \(item) {
              if (is.null(item) || length(item) == 0L) {
                NA_character_
              } else if (length(item) > 1L) {
                as.character(jsonlite::toJSON(item, auto_unbox = TRUE))
              } else {
                as.character(item)
              }
            },
            character(1L)
          )
        )
      }
      col
    })

    out <- as.data.frame(normalized, stringsAsFactors = FALSE)
    rownames(out) <- NULL
    return(out)
  }

  stop(
    "`json` must be a list of named records or a named list.",
    call. = FALSE
  )

}
