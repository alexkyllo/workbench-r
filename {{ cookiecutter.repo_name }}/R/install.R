## Install packages from CRAN that are not available from conda

packages <- c("AzureKusto", "AzureStor")

lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
})
