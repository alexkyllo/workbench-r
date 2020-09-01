## Install packages from CRAN that are not available from conda
packages <- c("AzureKusto", "AzureStor")

cat("Installing additional packages from CRAN using R/install.R\n")

installed <- lapply(packages, FUN = function(x) {
  cat(glue::glue("Checking for package {x}...\n"))
  if (!suppressMessages(require(x, character.only = TRUE))) {
    cat(glue::glue("Not found. installing package {x}...\n"))
    suppressMessages(install.packages(x, dependencies = TRUE))
    cat(glue::glue("Package {x} installed.\n"))
  }
})

cat("Done.\n")

