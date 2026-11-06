# Week 03 — Introduction to GLMs
# Rough exploratory work: Saema
# Keep everything; move good work into week03_final.R.
# Save outputs to outputs/week03/ with your name in the file name.

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

# WEEK 03 — Section 4: Grouping by team
# Aim: show how player outcomes vary by team and explain why clustering may matter.

# Summarise the outcomes by team.
team_summary <- players %>%
  group_by(team) %>%
  summarise(
    n_players = n(),
    injured_count = sum(injured, na.rm = TRUE),
    injury_rate = mean(injured, na.rm = TRUE),
    mean_minutes = mean(minutes_played, na.rm = TRUE),
    sd_minutes = sd(minutes_played, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(injury_rate))

print(team_summary)

# Injury rates by team.
ggplot(team_summary, aes(x = reorder(team, injury_rate), y = injury_rate)) +
  geom_col() + coord_flip() +
  labs(title = "Injury rate by team", x = "Team", y = "Proportion injured")

# Mean minutes played by team.
ggplot(team_summary, aes(x = reorder(team, mean_minutes), y = mean_minutes)) +
  geom_col() + coord_flip() +
  labs(title = "Mean minutes played by team", x = "Team", y = "Mean minutes")

# Show the spread of minutes played within each team.
ggplot(players, aes(x = team, y = minutes_played)) +
  geom_boxplot() + coord_flip() +
  labs(title = "Minutes played within each team", x = "Team", y = "Minutes played")

source("code/setup.R")
