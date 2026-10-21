source("code/setup.R")  # loads match_data and player_data from data/
# install.packages("tidyverse")  # run once in the Console if needed
library(tidyverse)

# Check the imported data
head(match_data)
dim(match_data)
str(match_data)

# Check the imported data
head(player_data)
dim(player_data)
str(player_data)

match_data <- match_data %>%
  mutate(
    home_away = factor(home_away)
  )

player_data <- player_data %>%
  mutate(
    team = factor(team),
    position = factor(position),
    training_load = factor(training_load, ordered = TRUE),
    injured = factor(injured, levels = c(0, 1),
                     labels = c("No", "Yes"))
  )

# Display variable types
str(match_data)
str(player_data)

# Check dataset dimensions
dim(match_data)
dim(player_data)

# Check missing values
colSums(is.na(match_data))
colSums(is.na(player_data))

#Variableclassification
# Match dataset:
# home_away       = categorical nominal
# goals_scored    = numerical discrete
# goals_conceded  = numerical discrete
# opponent_rank   = numerical discrete / ordinal

# Player dataset:
# team            = categorical nominal
# position        = categorical nominal
# age             = numerical discrete
# minutes_played  = numerical discrete
# training_load   = ordinal categorical
# prev_injuries   = numerical discrete
# bmi             = numerical continuous
# injured         = binary categorical

#summary statistic
# Overall summaries
summary(match_data)
summary(player_data)

# Match statistics
match_data %>%
  summarise(
    mean_goals_scored = mean(goals_scored, na.rm = TRUE),
    sd_goals_scored = sd(goals_scored, na.rm = TRUE),
    mean_goals_conceded = mean(goals_conceded, na.rm = TRUE),
    sd_goals_conceded = sd(goals_conceded, na.rm = TRUE),
    mean_opponent_rank = mean(opponent_rank, na.rm = TRUE)
  )

# Compare home and away matches
match_data %>%
  group_by(home_away) %>%
  summarise(
    number_of_matches = n(),
    average_goals_scored = mean(goals_scored, na.rm = TRUE),
    average_goals_conceded = mean(goals_conceded, na.rm = TRUE),
    .groups = "drop"
  )

# Player statistics
player_data %>%
  summarise(
    mean_age = mean(age, na.rm = TRUE),
    sd_age = sd(age, na.rm = TRUE),
    min_age = min(age, na.rm = TRUE),
    max_age = max(age, na.rm = TRUE),
    mean_minutes = mean(minutes_played, na.rm = TRUE),
    sd_minutes = sd(minutes_played, na.rm = TRUE),
    mean_bmi = mean(bmi, na.rm = TRUE),
    sd_bmi = sd(bmi, na.rm = TRUE),
    mean_previous_injuries = mean(prev_injuries, na.rm = TRUE)
  )

# Count players by position and team
table(player_data$position)
table(player_data$team)

# Count injured and non-injured players
table(player_data$injured)

# Injury rates by position
player_data %>%
  group_by(position) %>%
  summarise(
    total_players = n(),
    injured_players = sum(injured == "Yes", na.rm = TRUE),
    injury_rate = mean(injured == "Yes", na.rm = TRUE),
    .groups = "drop"
  )

# STEP 7: MATCH DATA PLOTS
# Plot 1: Goals scored at home and away
ggplot(match_data, aes(x = home_away, y = goals_scored)) +
  geom_boxplot(fill = "skyblue") +
  labs(
    title = "Goals Scored at Home and Away",
    x = "Match Location",
    y = "Goals Scored"
  ) +
  theme_minimal()

# Plot 2: Distribution of goals scored
ggplot(match_data, aes(x = goals_scored)) +
  geom_histogram(
    binwidth = 1,
    fill = "steelblue",
    color = "white"
  ) +
  scale_x_continuous(breaks = 0:8) +
  labs(
    title = "Distribution of Goals Scored",
    x = "Goals Scored",
    y = "Frequency"
  ) +
  theme_minimal()

# Plot 3: Goals scored versus opponent rank
ggplot(match_data,
       aes(x = opponent_rank, y = goals_scored,
           color = home_away)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Goals Scored vs Opponent Rank",
    x = "Opponent Rank",
    y = "Goals Scored",
    color = "Match Location"
  ) +
  theme_minimal()


# Plot 4: Distribution of player ages
ggplot(player_data, aes(x = age)) +
  geom_histogram(
    binwidth = 2,
    fill = "darkseagreen",
    color = "white"
  ) +
  labs(
    title = "Distribution of Player Ages",
    x = "Age",
    y = "Number of Players"
  ) +
  theme_minimal()

# Plot 5: BMI by playing position
ggplot(player_data, aes(x = position, y = bmi)) +
  geom_boxplot(fill = "orange") +
  labs(
    title = "BMI by Playing Position",
    x = "Position",
    y = "BMI"
  ) +
  theme_minimal()

# Plot 6: Minutes played versus previous injuries
ggplot(player_data,
       aes(x = prev_injuries, y = minutes_played)) +
  geom_point(alpha = 0.6, color = "purple") +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(
    title = "Minutes Played vs Previous Injuries",
    x = "Previous Injuries",
    y = "Minutes Played"
  ) +
  theme_minimal()

# STEP 7: CHECK REGRESSION ASSUMPTIONS

par(mfrow = c(2, 2))
plot(model1)
par(mfrow = c(1, 1))


# STEP 8: MULTIPLE LINEAR REGRESSION

model2 <- lm(
  minutes_played ~ age + position + training_load +
    prev_injuries + bmi,
  data = player_data
)

summary(model2)
confint(model2)


# STEP 9: LINEAR REGRESSION FOR MATCH DATA

model_match <- lm(
  goals_scored ~ opponent_rank + home_away,
  data = match_data
)

summary(model_match)


# STEP 10: SAVE YOUR RESULTS

write.csv(match_data, "match_data_imported.csv",
          row.names = FALSE)

write.csv(player_data, "player_data_imported.csv",
          row.names = FALSE)

write.csv(
  as.data.frame(coef(summary(model1))),
  "linear_regression_results.csv"
)

capture.output(
  summary(model1),
  file = "linear_regression_summary.txt"
)

getwd()

