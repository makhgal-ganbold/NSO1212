# NSO1212

*National Statistical Office of Mongolia's Open Data API Handler for R*

National Statistical Office of Mongolia (NSO) is the national statistical service and an organization of Mongolian government. NSO provides open access and official data via its web site [www.1212.mn](http://www.1212.mn/) and API [opendata.1212.mn](http://opendata.1212.mn/en/doc). The package NSO1212 has functions for accessing the API service. The functions are compatible with the API v2.0 and get data sets and its detailed informations from the API.

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
  PERIOD = c("201711", "201712", "201801"),
  CODE = c("10", "11"),
  CODE1 = "11"
)
print(nso.data)

table_info <- get_table_info("DT_NSO_2400_015V2")
table_info$unit_nm
table_info$obj[[1]]$itm[[1]]$scr_mn
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

[Makhgal Ganbold](http://galaa.mn/ "Galaa's Personal Page"), National University of Mongolia

## Copyright

&copy; 2019 Makhgal Ganbold
