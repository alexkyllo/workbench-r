# {{cookiecutter.repo_name}}

{{cookiecutter.description}}

## Project Organization

```
    ├── R/                 <- R source code for use in this project.
    │   ├── clean.R        <- Clean data in data/raw/ and output result to /data/processed
    │   ├── explore.R      <- Exploratory data analysis script for interactive work
    │   ├── get.R          <- Script to get data from the source
    │   ├── install.R      <- Script to install R packages (that are not available from conda)
    │   ├── plot.R         <- Script to plot visuals
    │   ├── render.R       <- Script to render the report.Rmd RMarkdown file into a document
    │   ├── report.Rmd     <- Analysis report writeup RMarkdown file
    │   ├── score.R        <- Script to score a trained model on test data
    │   ├── theme.R        <- A minimal blue/gray style theme for ggplot2 plots
    │   ├── train.R        <- Script to train a predictive model and save the model to a file
    │   └── utilities.R    <- Utility functions for use by other scripts.
    ├── data/
    │   ├── processed/     <- The cleaned, transformed data for modeling
    │   └── raw/           <- The original source data
    ├── figures/           <- Generated .png plot figures
    ├── models/            <- Trained and serialized models, model predictions, or model summaries
    ├── notebooks/         <- Jupyter notebooks
    ├── queries/           <- SQL and Kusto (Azure Data Explorer) queries used to retrive data
    ├── references/        <- Data dictionaries, manuals, and all other explanatory materials
    ├── reports/           <- Generated analysis as HTML, PDF, DOCX, etc.
    ├── .env               <- Environment variables including configurations and any secret keys
    ├── .gitignore         <- List of file patterns for Git to ignore from version control
    ├── .here              <- Tells the "here" package that this is the project root directory
    ├── LICENSE            <- MIT License
    ├── Makefile           <- Makefile with commands like `make data` or `make train`
    ├── README.md          <- The top-level README for developers using this project.
    └── environment.yml    <- conda environment configuration file.

```

## Installing

One-time setup 

```sh
make environment
make install
```

<p><small>Project based on the <a target="_blank" href="https://github.com/alexkyllo/workbench-r">workbench-r cookiecutter project template</a></small></p>
