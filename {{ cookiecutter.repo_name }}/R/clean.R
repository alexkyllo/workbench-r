## clean.R
## script for cleaning data
## takes source data from data/raw, processes it, and
## outputs the result to data/processed.

suppressMessages(library(here))
suppressMessages(library(glue))
suppressMessages(library(readr))
suppressMessages(library(dplyr))

input_file <- here("data/raw/raw_data.csv")

output_file <- here("data/processed/processed_data.csv")

cat(glue::glue("Reading input file {input_file}...\n"))
data <- suppressMessages(read_csv(input_file))
cat("Done.\n")

cat("Processing raw data...\n")

data <-
  data %>%
  mutate(
    TotalInjuries = InjuriesDirect + InjuriesIndirect,
    TotalDeaths = DeathsDirect + DeathsIndirect,
    TotalDamage = DamageProperty + DamageCrops,
    DurationInMinutes = as.numeric(x = EndTime - StartTime, units = "mins"),
    LogTotalDamage = log(TotalDamage),
    LogDurationInMinutes = log(DurationInMinutes)
  ) %>%
  filter(
    DurationInMinutes > 0,
    TotalDamage > 0
  )
cat("Done.\n")

cat(glue::glue("Writing processed data to {output_file}..."))
write_csv(data, output_file)
cat("Done. \n")
