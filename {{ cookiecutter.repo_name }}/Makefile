# Makefile
# This is an example Makefile to help you get familiar with GNU Make
# and get started with using it to automate your project build tasks.
# For the full GNU Make manual, see:
# https://www.gnu.org/software/make/manual/make.html
#
# A Makefile consists of rules, which take following form:
# target … : prerequisites …
#        recipe
#        …
#        …
#
# Multiple targets and prerequisites are separated by spaces;
# multiple recipes are separated by newlines.
#
# If the target file exists, and the file has not been modified since any
# of its prerequisite files were last modified, the rule will be skipped.
# This means that it won't redo any work that it doesn't need to!
#
# Some things to note:
# - Indentation must be tabs--Make will error if you use spaces.
# - To break a long line, use a backslash: \
# - If you just type "make" at the command line in the directory
# where the Makefile is, it will run the first recipe
# (after running its prerequisites).
# - Other than that, the ordering of the rules in the file doesn't matter.
# Make builds a dependency graph and performs a topological sort to determine
# the correct rule execution order.
# - If you type "make {rule name}" it will run that specific rule name
# (again, after running its prerequisites).
# - If you type "make -n" it will tell you what it's going to run without
# actually running it (a dry run).
#
# This includes your .env file variables in the Makefile
include .env
export

# Rules can either be file names (a rule for producing a file)
# or just task names that aren't files, called "phony rules."
# List any phony rules here so that Make knows not to look for
# files by these names:
.PHONY: style environment install data figures reports
#
#################################################################################
# COMMANDS                                                                      #
#################################################################################

## Format R code using styler
style:
	Rscript -e "library(styler); style_dir('./R')"

## Set up python interpreter environment
environment:
	conda env create -f environment.yml || conda env update -f environment.yml
	@echo ">>> Conda env created. Activate with:\nconda activate $(REPO_NAME)"

## Install the R packages
install:  R/install.R
	Rscript $<

#################################################################################
# PROJECT RULES                                                                 #
#################################################################################

## A rule to run all the project tasks
all: install data figures reports

## Render the HTML report
reports: reports/report.html

## Plot figures
figures: figures/scatter_plot.png

## Make the dataset by running queries
data: data/processed/processed_data.csv

# A recipe for a processed data file.
# This recipe says that
# data/processed/processed_data.csv
# depends on
# R/get_data.R and data/raw/raw_data.csv.
# The recipe to make it is: Rscript $<
# Rscript runs R scripts from the command line.
# $< is shorthand for "the first prerequisite in the list."
# Others to know are:
# $^ is all of the prerequisites in the list
# $@ is the target name
# So this recipe will run `Rscript R/clean.R`.
data/processed/processed_data.csv: R/clean.R data/raw/raw_data.csv
	Rscript $<

data/raw/raw_data.csv: R/get.R queries/query.csl
	Rscript $<

# A recipe for a trained ML model.
models/model.Rds data/processed/test_data.csv &: R/model/train.R data/processed/processed_data.csv
	Rscript $<

# A recipe for scoring the model on test data.
data/processed/scored_data.csv: R/model/score.R data/processed/test_data.csv
	Rscript $<

# A recipe for a visualization.
figures/scatter_plot.png : R/plot.R data/processed/scored_data.csv
	Rscript $<

# A recipe for an HTML report.
reports/report.html : R/render.R R/report.Rmd figures/scatter_plot.png
	Rscript $<


#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
.PHONY: help
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')
