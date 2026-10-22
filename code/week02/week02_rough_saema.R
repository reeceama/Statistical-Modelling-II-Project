# Week 02 — Exploration and normal linear regression
# Rough exploratory work: Saema
# Keep everything; move good work into week02_final.R.
# Save outputs to outputs/week02/ with your name in the file name.

players <- read.csv("league_players.csv")
matches <- read.csv("ashford_matches.csv")


# 2. EXPLORE THE DATA

# Number of rows and columns
dim(players)
dim(matches)

# Variable names
names(players)
names(matches)

# First six rows
head(players)
head(matches)

# Structure and variable types
str(players)
str(matches)

# Summary statistics
summary(players)
summary(matches)


# 3. CHECK FOR MISSING VALUES

colSums(is.na(players))
colSums(is.na(matches))


# 4. CLASSIFY CATEGORICAL VARIABLES

players$team <- as.factor(players$team)
players$position <- factor(
  players$position,
  levels = c("GK", "DEF", "MID", "FWD")
)

matches$home_away <- as.factor(matches$home_away)

# Frequency of each playing position
table(players$position)

# Number of players per team
table(players$team)

# Number of injured and non-injured players
table(players$injured)

# Proportion of players injured
prop.table(table(players$injured))


# 5. SUMMARY STATISTICS FOR NUMERICAL VARIABLES

numerical_variables <- c(
  "age",
  "minutes_played",
  "training_load",
  "prev_injuries",
  "bmi"
)

# Means
sapply(players[numerical_variables], mean)

# Medians
sapply(players[numerical_variables], median)

# Standard deviations
sapply(players[numerical_variables], sd)

# Minimum and maximum
sapply(players[numerical_variables], min)
sapply(players[numerical_variables], max)


# 6. HISTOGRAM: AGE

hist(
  players$age,
  main = "Distribution of Player Age",
  xlab = "Age (years)",
  ylab = "Number of Players",
  col = "lightblue",
  border = "white"
)


# 7. HISTOGRAM: MINUTES PLAYED

hist(
  players$minutes_played,
  main = "Distribution of Minutes Played",
  xlab = "Minutes Played",
  ylab = "Number of Players",
  col = "lightgreen",
  border = "white"
)


# 8. BOXPLOT: MINUTES PLAYED BY POSITION

boxplot(
  minutes_played ~ position,
  data = players,
  main = "Minutes Played by Position",
  xlab = "Playing Position",
  ylab = "Minutes Played",
  col = "lightblue"
)


# 9. SCATTERPLOT: AGE AND MINUTES PLAYED

plot(
  players$age,
  players$minutes_played,
  main = "Age vs Minutes Played",
  xlab = "Age (years)",
  ylab = "Minutes Played",
  pch = 19,
  col = "steelblue"
)

# Add a linear trend line
abline(
  lm(minutes_played ~ age, data = players),
  col = "red",
  lwd = 2
)


# 10. EXPLORE THE MATCH DATA

# Summary of match variables
summary(matches)

# Number of home and away matches
table(matches$home_away)

# Average goals scored and conceded at home and away
aggregate(
  cbind(goals_scored, goals_conceded) ~ home_away,
  data = matches,
  FUN = mean
)

# Histogram of goals scored
hist(
  matches$goals_scored,
  main = "Goals Scored by Ashford United",
  xlab = "Goals Scored",
  ylab = "Number of Matches",
  col = "lightblue"
)


# 11. NORMAL LINEAR REGRESSION

# Research question:
# How are age, training load, previous injuries,
# and playing position associated with minutes played?

model <- lm(
  minutes_played ~ age + training_load +
    prev_injuries + position,
  data = players
)

# Full regression results
summary(model)


# 12. CONFIDENCE INTERVALS FOR COEFFICIENTS

confint(model)


# 13. DIAGNOSTIC PLOTS

# Check linear regression assumptions
par(mfrow = c(2, 2))
plot(model)

# Return to one plot per screen
par(mfrow = c(1, 1))
# Week 02 — Exploration and normal linear regression
# Rough exploratory work: Saema
# Keep everything; move good work into week02_final.R.
# Save outputs to outputs/week02/ with your name in the file name.

source("code/setup.R")
