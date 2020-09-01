## plot.R
## Script to create plots. Reads processed data from data/processed,
## creates plots, and uses e.g. ggsave() to output PNGs to reports/figures

suppressMessages(library(here))
suppressMessages(library(readr))
suppressMessages(library(ggplot2))
suppressMessages(library(scales))


source(here("R/visualize/msft_ggtheme.R"))

input_file <- here("data/processed/scored_data.csv")
model_file <- here("models/model.Rds")
figure_file <- here("figures/scatter_plot.png")

data <- suppressMessages(read_csv(input_file))

# plot by continuous variable
scatter_plot <-
  ggplot(data = data, aes(x = LogDurationInMinutes, y = LogTotalDamage)) +
  geom_jitter() +
  scale_color_azure() +
  geom_line(aes(y = prediction, color = "blue"), size = 1) +
  theme_azure()

suppressMessages(ggsave(figure_file))
