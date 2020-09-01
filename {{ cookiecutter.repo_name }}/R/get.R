## get.R
## Run query on source database and export results to Blob Storage
## Then download the file from blob storage to data/raw/

library(here)
library(dotenv)
library(AzureKusto)
library(AzureStor)

source(here("R/utilities.R"))

load_dot_env()

## Set these variables in your .env file
repo_name <- Sys.getenv("REPO_NAME")
blob_account <- Sys.getenv("BLOB_ACCOUNT")
blob_container <- Sys.getenv("BLOB_CONTAINER")
blob_key <- Sys.getenv("BLOB_KEY")

## Edit these variables for your query
server <- "help"
database <- "Samples"
query_file <- here("queries/query.csl")
data_file <- here("data/raw/raw_data.csv")
prefix <- paste0(repo_name, "/raw_data")
dest <- here("data/raw")
gzip <- TRUE

## Run the query on Kusto, export the data to Azure Blob Storage,
## and download the CSV file to data/raw/
get_data_from_kusto_via_blob(
  server,
  database,
  query_file,
  data_file,
  blob_account,
  blob_container,
  prefix,
  blob_access_key,
  dest,
  gzip
)
