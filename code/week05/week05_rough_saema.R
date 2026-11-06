# Week 05 — Residuals and diagnostics
# Rough exploratory work: Saema
# Keep everything; move good work into week05_final.R.
# Save outputs to outputs/week05/ with your name in the file name.

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

# WEEK 05 — Section 1: Linear-model residual diagnostics
# Aim: produce diagnostic plots for the Week 2 final linear model.
# IMPORTANT: use exactly the formula selected by the group in Week 2.
# The formula below is a working version; edit it if your group's final model differs.

linear_final <- lm(
  minutes_played ~ age + training_load + prev_injuries + bmi + position,
  data = players)
summary(linear_final)

# Standard four diagnostic plots.
par(mfrow = c(2, 2))
plot(linear_final)
par(mfrow = c(1, 1))

# Separate residual-versus-fitted plot.
diagnostics <- data.frame(
  fitted = fitted(linear_final),
  residual = residuals(linear_final),
  standardised_residual = rstandard(linear_final))

ggplot(diagnostics, aes(x = fitted, y = residual)) +
  geom_point(alpha = 0.6) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_smooth(se = FALSE) +
  labs(
    title = "Residuals versus fitted values",
    x = "Fitted minutes played", y = "Residual")

# Normal Q-Q plot.
ggplot(diagnostics, aes(sample = standardised_residual)) +
  stat_qq() + stat_qq_line() +
  labs(title = "Normal Q-Q plot of standardised residuals")

# Flag unusually large standardised residuals for investigation.
which(abs(diagnostics$standardised_residual) > 3)

# Report point:
# Look for curvature (possible non-linearity), a funnel shape (non-constant
# variance), departures from the Q-Q line (non-normal residuals), and
# observations with unusually large residuals. Explain what the plots show;
# do not claim assumptions hold automatically.
source("code/setup.R")
