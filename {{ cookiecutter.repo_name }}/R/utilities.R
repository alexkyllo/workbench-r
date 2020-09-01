## utilities.R
## Helper functions to do things like connect to Kusto,
## export data to Azure Blob Storage as CSV,
## and download to your local data/raw directory.

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

get_data_from_blob <- function(account, container, prefix, key, dest) {
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

make_export_query <- function(query_file, url, prefix, key) {
  query <- readr::read_file(query_file)

  export_query <- glue::glue('.export to csv
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

export_data_from_kusto_to_blob <- function(server,
                                           database,
                                           query_file,
                                           account,
                                           container,
                                           prefix,
                                           key) {
  server_url <- glue::glue("https://{server}.kusto.windows.net/")
  url <- glue::glue("https://{account}.blob.core.windows.net/{container}")
  cat(glue::glue("Running {query_file} and exporting to {url}...\n"))
  endpoint <- AzureKusto::kusto_database_endpoint(
    server = server_url,
    database = database
  )

  command <- make_export_query(query_file, url, prefix, key)

  AzureKusto::run_query(endpoint, command)
  cat("Done.\n")
}

get_data_from_kusto_via_blob <- function(server,
                                         database,
                                         query_file,
                                         data_file,
                                         account,
                                         container,
                                         prefix,
                                         key,
                                         dest,
                                         gzip) {
  export_data_from_kusto_to_blob(
    server,
    database,
    query_file,
    account,
    container,
    prefix,
    key
  )

  get_data_from_blob(account, container, prefix, key, dest)
}
