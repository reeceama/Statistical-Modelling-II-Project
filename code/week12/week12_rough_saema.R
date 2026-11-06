# Week 12 — Choosing analyses and planning the report
# Rough exploratory work: Saema
# Keep everything; move good work into week12_final.R.
# Save outputs to outputs/week12/ with your name in the file name.
library(ggplot2)
library(dplyr)
library(tidyr)

players <- read.csv("league_players.csv")
matches <- read.csv("ashford_matches.csv")

players <- players %>%
  mutate(
    team = factor(team),
    position = factor(position),
    training_load = ordered(training_load, levels = 1:5),
    injured = as.integer(injured))

matches <- matches %>%
  mutate(home_away = factor(home_away, levels = c("Away", "Home")))

# WEEK 12 — Section 2: Choose three analyses and justify the choice
# This is mainly a planning/write-up task. The code below creates a shortlist
# table to help compare candidate analyses; the final choice must be agreed
# with the group and justified using the actual results and diagnostics.

candidate_analyses <- data.frame(
  analysis = c(
    "Logistic regression: injured",
    "Linear regression: minutes_played",
    "Poisson regression: goals_scored",
    "Mixed logistic regression: injured by team",
    "Home/away by match result contingency table"
  ),
  strengths = c(
    "Directly models the binary injury outcome; effects can be expressed as odds ratios",
    "Models a continuous player outcome; coefficients and confidence intervals are familiar",
    "Models match goal counts; effects can be expressed as rate ratios",
    "Allows baseline injury risk to vary across teams",
    "Simple, interpretable comparison of match outcomes by venue"
  ),
  limitations = c(
    "Requires fit checks; odds ratios need careful contextual interpretation",
    "Requires residual and variance assumptions to be assessed",
    "Only 46 matches; check overdispersion and excess zeros",
    "More complex; team variance may be estimated imprecisely",
    "Small sample and potentially sparse expected cell counts"
  ),
  stringsAsFactors = FALSE)

print(candidate_analyses)

# Suggested three to discuss (not an automatic final decision):
# 1. Logistic regression for injured — important binary player outcome.
# 2. Linear regression for minutes_played — complementary continuous outcome.
# 3. Poisson regression for goals_scored — adds a match-level count outcome.
#
# Before finalising, check:
# - Does each analysis answer the project's research question?
# - Are the model assumptions reasonably supported by diagnostics?
# - Are the results interpretable and supported by adequate data?
# - Do the three analyses provide complementary rather than repetitive findings?
#
# Add the group's agreed choices and reasons to the report plan.

source("code/setup.R")
