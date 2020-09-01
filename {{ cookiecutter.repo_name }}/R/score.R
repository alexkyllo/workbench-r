## score.R
## Score fitted models on test data

suppressMessages(library(here))
suppressMessages(library(readr))
suppressMessages(library(dplyr))

input_file <- here("data/processed/test_data.csv")
model_file <- here("models/model.Rds")
output_file <- here("data/processed/scored_data.csv")

cat(glue::glue("Reading saved model from {model_file}...\n"))
model <- readRDS(model_file)
cat("Done.\n")

cat(glue::glue("Testing model on test data in {input_file}...\n"))
test_data <- suppressMessages(read_csv(input_file))
test_data$prediction <- predict(model, test_data)
cat("Done.\n")

cat(glue::glue("Writing scored test data to {output_file}...\n"))
write_csv(test_data, output_file)
cat("Done.\n")
