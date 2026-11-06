# Week 10 — Specialised models
# Rough exploratory work: Saema
# Keep everything; move good work into week10_final.R.
# Save outputs to outputs/week10/ with your name in the file name.
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

# WEEK 10 — Section 5: Check for excess zeros in count outcomes
# Aim: compare observed zero counts with the number expected under Poisson models.

check_zeros <- function(response_name, data) {
  model_formula <- as.formula(
    paste(response_name, "~ home_away + opponent_rank")
  )
  model <- glm(
    model_formula,
    family = poisson(link = "log"),
    data = data)

  observed_zero_count <- sum(data[[response_name]] == 0, na.rm = TRUE)
  expected_zero_count <- sum(dpois(0, lambda = fitted(model)), na.rm = TRUE)

  data.frame(
    outcome = response_name,
    observed_zeros = observed_zero_count,
    expected_zeros = expected_zero_count,
    observed_zero_proportion = observed_zero_count / nrow(data),
    expected_zero_proportion = expected_zero_count / nrow(data),
    AIC = AIC(model))}

zero_summary <- bind_rows(
  check_zeros("goals_scored", matches),
  check_zeros("goals_conceded", matches))
print(zero_summary)

# Plot observed and Poisson-expected frequencies for each count value.
plot_count_comparison <- function(response_name, data) {
  model_formula <- as.formula(
    paste(response_name, "~ home_away + opponent_rank"))
  model <- glm(model_formula, family = poisson, data = data)

  observed_values <- data[[response_name]]
  max_value <- max(observed_values, na.rm = TRUE)
  count_values <- 0:max_value

  observed_frequency <- vapply(
    count_values, function(k) sum(observed_values == k, na.rm = TRUE),
    numeric(1))
  expected_frequency <- vapply(
    count_values,
    function(k) sum(dpois(k, lambda = fitted(model))),
    numeric(1))

  plot_data <- data.frame(
    goals = count_values,
    Observed = observed_frequency,
    `Poisson expected` = expected_frequency,
    check.names = FALSE
  ) %>%
    pivot_longer(
      cols = c("Observed", "Poisson expected"),
      names_to = "frequency_type", values_to = "frequency")

  ggplot(plot_data, aes(x = goals, y = frequency, fill = frequency_type)) +
    geom_col(position = "dodge") +
    labs(
      title = paste("Observed and Poisson-expected counts:", response_name),
      x = "Goals", y = "Frequency", fill = "Frequency")}

plot_count_comparison("goals_scored", matches)
plot_count_comparison("goals_conceded", matches)

# Report point:
# If observed zeros substantially exceed the Poisson expectation, this may
# indicate excess zeros, but it is only a diagnostic comparison—not a formal
# test. The dataset contains 46 matches, so conclusions should be cautious.

source("code/setup.R")
