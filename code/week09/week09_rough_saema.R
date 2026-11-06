# Week 09 — Contingency tables II
# Rough exploratory work: Saema
# Keep everything; move good work into week09_final.R.
# Save outputs to outputs/week09/ with your name in the file name.

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

# WEEK 09 — Section 4: Conditional odds ratios
# Aim: assess the position-injury association separately at each training-load
# level. DEF is used as the reference position.

players$position <- relevel(factor(players$position), ref = "DEF")

# Descriptive injury counts and rates for every training-load/position group.
conditional_summary <- players %>%
  group_by(training_load, position) %>%
  summarise(
    n = n(),
    injured_n = sum(injured, na.rm = TRUE),
    injury_rate = mean(injured, na.rm = TRUE),
    .groups = "drop")
print(conditional_summary)

# Fit a separate logistic model within each training-load category.
load_levels <- levels(players$training_load)
conditional_models <- setNames(vector("list", length(load_levels)),
                               paste0("Load_", load_levels))

for (lev in load_levels) {
  dat <- filter(players, training_load == lev)
  conditional_models[[paste0("Load_", lev)]] <-
    glm(injured ~ position, family = binomial, data = dat)}

# Exponentiated coefficients are odds ratios relative to DEF.
# Wald 95% CIs are used here to avoid profile-CI failures in sparse subgroups.
for (nm in names(conditional_models)) {
  cat("\\n", nm, "\\n")
  mod <- conditional_models[[nm]]
  print(summary(mod))
  odds_ratios <- exp(cbind(
    OR = coef(mod),
    confint.default(mod)
  ))
  print(odds_ratios)}

# Plot observed injury rates by position for each training-load level.
ggplot(conditional_summary, aes(
  x = position, y = injury_rate,
  colour = training_load, group = training_load
)) +
  geom_point(size = 2) + geom_line() +
  labs(
    title = "Injury rate by position within training-load levels",
    x = "Position", y = "Observed injury proportion",
    colour = "Training load")

# Report point:
# For each load level, compare each position's odds of injury with DEF.
# Mention subgroup sample sizes and any warnings about separation or very wide
# confidence intervals. A subgroup with no injuries or no non-injuries can
# produce unstable/infinite ordinary logistic estimates.
source("code/setup.R")
