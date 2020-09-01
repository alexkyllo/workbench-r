## Install packages from CRAN that are not available from conda

packages <- c("AzureKusto", "AzureStor")

cat("Installing the R packages from CRAN listed in R/install.R ...\n")
lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
})
cat("Done.\n")