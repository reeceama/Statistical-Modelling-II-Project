# Week 08 — Contingency tables I
# Rough exploratory work: Saema
# Keep everything; move good work into week08_final.R.
# Save outputs to outputs/week08/ with your name in the file name.

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

# WEEK 08 — Section 3: Match results and home/away association
# Aim: derive win/draw/loss and test home_away x result.

matches <- matches %>%
  mutate(
    result = case_when(
      goals_scored > goals_conceded ~ "Win",
      goals_scored == goals_conceded ~ "Draw",
      goals_scored < goals_conceded ~ "Loss"
    ),
    result = factor(result, levels = c("Loss", "Draw", "Win")))

# Contingency table: counts.
result_table <- table(matches$home_away, matches$result)
result_table

# Row proportions: within each venue, proportions of losses, draws and wins.
prop.table(result_table, margin = 1)

# Chi-squared test and expected counts.
chi_result <- chisq.test(result_table, correct = FALSE)
chi_result
chi_result$expected
chi_result$stdres

# If expected counts are too small, report Fisher's exact test as an
# alternative for this 2 x 3 table.
fisher.test(result_table)

# Stacked proportional bar chart.
ggplot(matches, aes(x = home_away, fill = result)) +
  geom_bar(position = "fill") +
  labs(
    title = "Match result proportions by venue",
    x = "Venue", y = "Proportion of matches", fill = "Result")

# Report point:
# Describe the home and away result proportions, state the test statistic,
# degrees of freedom and p-value, and comment on expected counts. There are
# only 46 matches, so interpret the test with appropriate caution.

source("code/setup.R")
