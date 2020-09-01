## get.R
## Run query on source database and export results to Blob Storage
## Then download the file from blob storage to data/raw/

suppressMessages(library(here))
suppressMessages(library(dotenv))

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
prefix <- "raw_data"
dest <- here("data/raw")
gzip <- FALSE

## Run the query on Kusto, export the data to Azure Blob Storage,
## and download the CSV file to data/raw/
get_data_from_kusto_via_blob(
  server = server,
  database = database,
  query_file = query_file,
  account = blob_account,
  container = blob_container,
  key = blob_key,
  folder = repo_name,
  prefix = prefix,
  dest = dest,
  gzip = gzip
)

rename_from <- paste0(dest, "/", prefix, "_1.csv")
rename_to <- paste0(dest, "/", prefix, ".csv")

if (file.exists(rename_to)) file.remove(rename_to)

renamed <- file.rename(from = rename_from, to = rename_to)
