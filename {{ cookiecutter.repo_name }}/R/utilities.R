## utilities.R
## Helper functions to do things like connect to Kusto,
## export data to Azure Blob Storage as CSV,
## and download to your local data/raw directory.

#' Get data from Kusto by running a query and downloading results to CSV
#' @param server The Kusto server name (not the full URI)
#' @param database The Kusto database name
#' @param query_file The path to the Kusto query file to run.
#' @param data_file The path to write the data file to.
#' This uses readr::write_csv so it will automatically gzip compress your file
#' if the extension is ".csv.gz" for example
get_data_from_kusto <- function(server, database, query_file, data_file) {
  cat(glue::glue("Connecting to Kusto cluster('{server}')
.database('{database}')..."))
  server_url <- glue::glue("https://{server}.kusto.windows.net/")
  endpoint <- AzureKusto::kusto_database_endpoint(
    server = server_url,
    database = database
  )

  cat(glue::glue("Running {query_file}..."))

  query <- readr::read_file(query_file)
  result <- AzureKusto::run_query(endpoint, query)
  cat(paste0("Done.\n"))

  cat(glue::glue("Writing results to {data_file}..."))
  dir.create(dirname(data_file), showWarnings = FALSE)
  readr::write_csv(result, data_file)
  cat(paste0("Done.\n"))
}

#' Download a file from an Azure Blob Storage container
#' @param account The Azure Blob Storage account name
#' @param container The Azure Blob Storage container name
#' @param key Your Azure Blob Storage access key
#' @param prefix The file name prefix for the files to download.
#' @param dest The local path to write the data file to.
get_data_from_blob <- function(account, container, key, prefix, dest) {
  url <- glue::glue("https://{account}.blob.core.windows.net/{container}")
  cat(
    glue::glue(
      "Downloading data files with prefix {prefix} from {url}\n"
    )
  )
  blob <- AzureStor::blob_container(url, key = key)
  blob_names <- AzureStor::list_blobs(blob)$name
  dir.create(dest, showWarnings = FALSE)
  AzureStor::multidownload_blob(blob,
    paste0(prefix, "*.*"),
    dest,
    overwrite = TRUE
  )
}

#' Generate a Kusto export command to run a query and send the
#' resulting file to Azure Blob Storage
#' @param query_file The path to the Kusto query file to run.
#' @param url The Azure Blob Storage URL to export data to.
#' @param prefix The filename prefix to name the exported file.
#' @param key Your Azure Blob Storage access key
#' @param gzip Whether you want to gzip compress the data file or not.
make_export_query <- function(query_file, url, prefix, key, gzip=FALSE) {
  query <- readr::read_file(query_file)
  compressed <- ifelse(gzip, "compressed", "")
  export_query <- glue::glue('.export {compressed} to csv
(h@"{url}/{prefix};{key}")
with(
    sizeLimit=1073741824,
    namePrefix={prefix},
    fileExtension=csv,
    includeHeaders=firstFile,
    encoding=UTF8NoBOM,
    distributed=false
)
<|
{query}')
}

#' Concatenate a set of CSV files together by appending the rows.
#' @param prefix The filename prefix to name the exported file.
#' @param dest The local path to write the data file to.
concatenate_files <- function(prefix, dest) {
  path <- glue::glue("{dest}/{prefix}")
  dest_path <- glue::glue("{dest}/{prefix}.csv")
  files <- list.files(
    path = path,
    full.names = TRUE
  )

  readr::write_file("", dest_path)
  cat(glue::glue("Concatenating {length(files)} files from {path} to {dest_path}...\n"))

  for (f in files)
  {
    file_data <- readr::read_file(f)
    readr::write_file(file_data, dest_path, append = TRUE)
  }
  cat("Done.\n")
}

#' Get data from Kusto by running a query and exporting results to
#' a CSV in Azure Blob Storage.
#' @param server The Kusto server name (not the full URI)
#' @param database The Kusto database name
#' @param query_file The path to the Kusto query file to run.
#' @param account The Azure Blob Storage account name
#' @param container The Azure Blob Storage container name
#' @param key Your Azure Blob Storage access key
#' @param prefix The file name prefix for the files to download.
#' @param gzip Whether you want to gzip compress the data file or not.
export_data_from_kusto_to_blob <- function(server,
                                           database,
                                           query_file,
                                           account,
                                           container,
                                           key,
                                           prefix,
                                           gzip=FALSE) {
  server_url <- glue::glue("https://{server}.kusto.windows.net/")
  url <- glue::glue("https://{account}.blob.core.windows.net/{container}")
  cat(glue::glue("Running {query_file} and exporting to {url}...\n"))

  endpoint <- AzureKusto::kusto_database_endpoint(
    server = server_url,
    database = database
  )

  command <- make_export_query(query_file, url, prefix, key, gzip)
  AzureKusto::run_query(endpoint, command)
  cat("Done.\n")
}

#' Get data from Kusto by running a query and exporting results to
#' a CSV in Azure Blob Storage, then downloading the files to a
#' local path.
#' @param server The Kusto server name (not the full URI)
#' @param database The Kusto database name
#' @param query_file The path to the Kusto query file to run.
#' @param account The Azure Blob Storage account name
#' @param container The Azure Blob Storage container name
#' @param key Your Azure Blob Storage access key
#' @param prefix The file name prefix for the files to download.
#' @param dest The local path to write the data file to.
#' @param gzip Whether you want to gzip compress the data file or not.
get_data_from_kusto_via_blob <- function(server,
                                         database,
                                         query_file,
                                         account,
                                         container,
                                         key,
                                         prefix,
                                         dest,
                                         gzip=FALSE) {
  export_data_from_kusto_to_blob(server,
                                 database,
                                 query_file,
                                 account,
                                 container,
                                 key,
                                 prefix,
                                 gzip)
  get_data_from_blob(account, container, key, prefix, dest)
}
