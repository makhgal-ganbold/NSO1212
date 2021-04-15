# NSO1212

*National Statistical Office of Mongolia's Open Data API Handler for R*

National Statistical Office of Mongolia (NSO) is the national statistical service and an organization of Mongolian government. NSO provides open access to official data via its API [opendata.1212.mn](http://opendata.1212.mn/en/doc). The package NSO1212 has functions for accessing the API service. The functions are compatible with the API v2.0 and get data-sets and its detailed information from the API.

## Features

1. Get brief information about all tables on the API
2. Download statistical data from the API
3. Get detailed information about a table and its classification on the API
4. Get detailed information about all sectors on the API
5. Get detailed information about a sub-sector on the API

## Example

```R
all.tables <- all_tables()
print(all.tables$tbl_nm)
print(all.tables$tbl_id)

nso.data <- get_table(
  tbl_id = "DT_NSO_2400_015V2",
  PERIOD = make_period(start = "201711", end = "202103", period = "M"),
  CODE = c("10", "11"),
  CODE1 = "11"
)
print(nso.data)

table_info <- get_table_info("DT_NSO_2400_015V2", simplify = TRUE)
str(table_info)
```

## Installation

From CRAN

```R
install.packages("NSO1212")
```

From the repository on GitHub

```R
install.packages("devtools")
devtools::install_github("galaamn/NSO1212")
```

## Author

[Makhgal Ganbold](https://www.galaa.mn/ "Galaa's Personal Page"), National University of Mongolia

## Copyright

&copy; 2019 - 2021 Makhgal Ganbold
