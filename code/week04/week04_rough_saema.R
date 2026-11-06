# Week 04 — Binomial regression
# Rough exploratory work: Saema
# Keep everything; move good work into week04_final.R.
# Save outputs to outputs/week04/ with your name in the file name.

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

# WEEK 04 — Section 5: Fitted injury probabilities
# Aim: plot predicted injury risk across training load and position.
# This section fits a working full logistic model so the plot can be produced.
# If the group supplies a selected Week 4 model, replace `injury_model`
# with that agreed model and use the same predictor names.

injury_model <- glm(
  injured ~ age + training_load + prev_injuries + bmi + position,
  family = binomial(link = "logit"),
  data = players)
summary(injury_model)

# Prediction grid: vary training load and position, holding other numeric
# predictors at their sample means.
new_data <- expand.grid(
  training_load = levels(players$training_load),
  position = levels(players$position),
  age = mean(players$age, na.rm = TRUE),
  prev_injuries = mean(players$prev_injuries, na.rm = TRUE),
  bmi = mean(players$bmi, na.rm = TRUE))
new_data$training_load <- ordered(
  new_data$training_load, levels = levels(players$training_load))
new_data$position <- factor(new_data$position, levels = levels(players$position))

# Calculate fitted probabilities and approximate 95% confidence intervals
# on the logit scale, then transform them back to probabilities.
pred <- predict(injury_model, newdata = new_data, type = "link", se.fit = TRUE)
new_data$linear_predictor <- as.numeric(pred$fit)
new_data$se <- as.numeric(pred$se.fit)
new_data$probability <- plogis(new_data$linear_predictor)
new_data$lower_95 <- plogis(new_data$linear_predictor - 1.96 * new_data$se)
new_data$upper_95 <- plogis(new_data$linear_predictor + 1.96 * new_data$se)

print(new_data)

ggplot(new_data, aes(
  x = training_load, y = probability,
  colour = position, group = position
)) +
  geom_line() + geom_point(size = 2) +
  geom_errorbar(aes(ymin = lower_95, ymax = upper_95), width = 0.12) +
  coord_cartesian(ylim = c(0, 1)) +
  labs(
    title = "Predicted injury probability by training load and position",
    x = "Training load", y = "Predicted probability of injury",
    colour = "Position")

# Report point:
# Describe how fitted risk changes with training load and whether the pattern
# differs by position. These are model-based predictions, not raw injury rates.
source("code/setup.R")
