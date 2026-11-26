# NSO1212

*National Statistical Office of Mongolia's Open Data API Handler for R*

The National Statistical Office of Mongolia (NSO) is the national statistical service and an organization of the Mongolian government. NSO provides open access to official data via its API [www.1212.mn/en/data-base/open-data](https://www.1212.mn/en/data-base/open-data). The package NSO1212 has functions for accessing the API service. The functions are compatible with the API v1.0 and get data sets and their detailed information from the API.

## Installation

From CRAN

```R
install.packages("NSO1212")
```

From the repository on GitHub

```R
install.packages("devtools")
devtools::install_github("makhgal-ganbold/NSO1212")
```

## Example

```R
# sectors
sectors <- nso_sectors(language = "en")
print(sectors)

# subsectors
subsectors <- nso_subsectors(
  sector_id = "Population, household",
  language = "en"
)
print(subsectors)

# list of tables
tables <- nso_tables(
  sector_id = "Population, household",
  subsector_id = "1_Population, household",
  language = "en"
)
print(tables)

# download table meta data
tbl_meta <- nso_table(
  sector_id = "Population, household",
  subsector_id = "1_Population, household",
  table_id = "DT_NSO_0300_004V1.px",
  language = "en"
)

# table caption
tbl_meta$title

# the number of codes
length(tbl_meta$variables)

# code values
tbl_meta$variables[[1]]
tbl_meta$variables[[2]]
tbl_meta$variables[[3]]

# query
query <- '{
 "query": [
   {"code": "Хүм амын тоо", "selection": {"filter": "item", "values": ["0"]}},
   {"code": "Бүс", "selection": {"filter": "item", "values": ["0"]}},
   {"code": "Он", "selection": {"filter": "item", "values": ["0", "1"]}}
 ],
 "response": {"format": "json-stat2"}
}'

# download data
data <- nso_data(
  sector_id = "Population, household",
  subsector_id = "1_Population, household",
  table_id = "DT_NSO_0300_004V1.px",
  query = query,
  language = "en"
)

# print downloaded data
print(data$df)
```

## Author

[Makhgal Ganbold](https://www.galaa.net/), National University of Mongolia

## Copyright

&copy; 2019 - 2026 Makhgal Ganbold
