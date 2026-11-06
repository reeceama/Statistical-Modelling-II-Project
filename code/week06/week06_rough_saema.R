# Week 06 — Poisson regression
# Rough exploratory work: Saema
# Keep everything; move good work into week06_final.R.
# Save outputs to outputs/week06/ with your name in the file name.

library(ggplot2)
library(dplyr)
library(tidyr)

players <- read.csv("data/league_players.csv")
matches <- read.csv("data/ashford_matches.csv")

players <- players %>%
  mutate(
    team = factor(team),
    position = factor(position),
    training_load = ordered(training_load, levels = 1:5),
    injured = as.integer(injured))

matches <- matches %>%
  mutate(home_away = factor(home_away, levels = c("Away", "Home")))

# WEEK 06 — Section 2: Poisson model selection for goals_scored
# Aim: test the home_away x opponent_rank interaction and each main term.

# Full model including interaction.
poisson_full <- glm(
  goals_scored ~ home_away * opponent_rank,
  family = poisson(link = "log"),
  data = matches)
summary(poisson_full)

# Additive model without interaction.
poisson_additive <- glm(
  goals_scored ~ home_away + opponent_rank,
  family = poisson(link = "log"),
  data = matches)

# Likelihood-ratio test: does the interaction improve the model?
anova(poisson_additive, poisson_full, test = "Chisq")

# Test each term in the additive model by deleting one term at a time.
drop1(poisson_additive, test = "Chisq")

# AIC comparison: lower AIC indicates a better trade-off between fit and
# complexity among the models being compared.
AIC(poisson_additive, poisson_full)

# Also compare the null model with the additive model.
poisson_null <- glm(goals_scored ~ 1, family = poisson, data = matches)
anova(poisson_null, poisson_additive, test = "Chisq")
AIC(poisson_null, poisson_additive, poisson_full)

# Report point:
# State whether the interaction is supported by the likelihood-ratio test
# and AIC. Then report which main effects are retained. Use the test results,
# AIC, model hierarchy and subject context together; do not select terms from
# p-values alone.

source("code/setup.R")
