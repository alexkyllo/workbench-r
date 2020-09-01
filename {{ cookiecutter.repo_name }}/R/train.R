## train.R
## Fit and train regression and ML models
## Read data from data/processed/, fit models, and save serialized fitted
## models to models/ folder

suppressMessages(library(here))
suppressMessages(library(readr))
suppressMessages(library(dplyr))
suppressMessages(library(scales))

input_file <- here("data/processed/processed_data.csv")
model_file <- here("models/model.Rds")
output_file <- here("data/processed/test_data.csv")
train_file <- here("data/processed/train_data.csv")

data <- suppressMessages(read_csv(input_file))

set.seed(123)

train_split <- 0.8

train_data <-
  data %>%
  sample_frac(train_split)

train_index <- as.numeric(rownames(train_data))

test_data <- data[-train_index, ]

cat(glue::glue("Writing train data to {train_file}...\n"))
write_csv(train_data, train_file)
cat("Done.\n")

cat(glue::glue("Writing test data to {output_file}...\n"))
write_csv(test_data, output_file)
cat("Done.\n")

cat(glue::glue("Training model on {percent(train_split)} of {input_file}...\n"))
model <- lm(LogTotalDamage ~ LogDurationInMinutes, data = train_data)
cat("Done.\n")

cat(glue::glue("Saving model to {model_file}...\n"))
saveRDS(model, model_file)
cat("Done.\n")
