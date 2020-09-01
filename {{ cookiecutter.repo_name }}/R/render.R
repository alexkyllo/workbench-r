# Render the Rmd report
suppressMessages(library(here))
suppressMessages(library(glue))
suppressMessages(library(rmarkdown))

report_input <- here("R/report.Rmd")
report_output <- here("reports/report.html")

cat(glue("Rendering report {report_input}...\n"))

rmarkdown::render(report_input,
  output_file = report_output,
  quiet = TRUE
)

cat(glue("Rendered report to: {report_output}\n"))
