# Week 11 — Generalised linear mixed models
# Rough exploratory work: Saema
# Keep everything; move good work into week11_final.R.
# Save outputs to outputs/week11/ with your name in the file name.

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

# WEEK 11 — Section 1: Random team intercept in logistic injury model
# Aim: fit a GLMM with team as a random intercept using lme4::glmer.

if (!requireNamespace("lme4", quietly = TRUE)) install.packages("lme4")
library(lme4)

# Fixed-effects logistic model for comparison.
# Use the same fixed-effect terms as the group's selected Week 4 model.
injury_glm <- glm(
  injured ~ age + training_load + prev_injuries + bmi + position,
  family = binomial(link = "logit"),
  data = players)

# Logistic mixed model: players are nested within teams.
injury_glmm <- glmer(
  injured ~ age + training_load + prev_injuries + bmi + position +
    (1 | team),
  family = binomial(link = "logit"),
  data = players,
  control = glmerControl(optimizer = "bobyqa"))

summary(injury_glmm)

# Estimated between-team random-intercept variance and standard deviation.
variance_table <- as.data.frame(VarCorr(injury_glmm))
print(variance_table)
team_variance <- variance_table$vcov[1]
team_sd <- sqrt(team_variance)
team_variance
team_sd

# Compare AIC values. These models have the same fixed effects, but note that
# likelihood comparisons between GLM and GLMM should be interpreted carefully.
AIC(injury_glm, injury_glmm)

# Compare fixed-effect estimates.
comparison <- data.frame(
  term = names(coef(injury_glm)),
  logistic_GLM = unname(coef(injury_glm)),
  logistic_GLMM = unname(fixef(injury_glmm)))
print(comparison)

# Report point:
# Explain that the random intercept allows baseline injury risk to vary by team.
# Report the estimated team-level variance. Compare the fixed-effect estimates
# with the ordinary logistic model and discuss whether conclusions change.

source("code/setup.R")
