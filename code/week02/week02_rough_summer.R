# Week 02 — Exploration and normal linear regression
# Rough exploratory work: Summer
# Keep everything; move good work into week02_final.R.
# Save outputs to outputs/week02/ with your name in the file name.

source("code/setup.R")


# Check that the player dataset loaded
head(player_data)

# Check the number of players and variables
dim(player_data)


# SECTION 2 - Summary statistics

# Check the summary of previous injuries
summary(player_data$prev_injuries)

# Check the summary of minutes played
summary(player_data$minutes_played)

# Calculate the mean number of previous injuries
mean(player_data$prev_injuries, na.rm = TRUE)

# Calculate the mean minutes played
mean(player_data$minutes_played, na.rm = TRUE)

# Check for missing values in both variables
sum(is.na(player_data$prev_injuries))
sum(is.na(player_data$minutes_played))

# SECTION 3 - Exploring the relationship

# Calculate average minutes for each injury count
aggregate(
  minutes_played ~ prev_injuries,
  data = player_data,
  FUN = mean
)

# Create a scatterplot to explore the relationship
plot(
  jitter(player_data$prev_injuries, amount = 0.12),
  player_data$minutes_played,
  main = "Previous Injuries vs Minutes Played",
  xlab = "Number of Previous Injuries",
  ylab = "Total Minutes Played",
  pch = 19,
  col = "steelblue"
)

# SECTION 4 - Normal linear regression

# Investigate whether previous injuries are
# associated with total minutes played

# Fit the linear regression model
minutes_model <- lm(
  minutes_played ~ prev_injuries,
  data = player_data
)

# Display the regression results
summary(minutes_model)

# Calculate confidence intervals
confint(minutes_model)

# SECTION 5 - Regression diagnostics

# Display four diagnostic plots
par(mfrow = c(2, 2))
plot(minutes_model)

# Return to one plot at a time
par(mfrow = c(1, 1))

# SECTION 6 - Interpretation of results

# The fitted regression coefficient for previous
# injuries is approximately -0.83.

# This suggests a very small negative association
# between previous injuries and minutes played.

# The p-value is approximately 0.975, which is
# greater than the 5% significance level.

# Therefore, there is insufficient evidence of
# a linear relationship between previous injuries
# and total minutes played.

# The confidence interval includes zero,
# supporting this conclusion.

# Diagnostic plots show some deviations from
# normality in the tails, although the residual
# spread appears reasonably stable.

# This is an exploratory model, and a lack of
# statistical significance does not prove
# that no relationship exists.

# SECTION 7 - Save diagnostic plots

# Create the output folder if necessary
dir.create("outputs/week02",
           recursive = TRUE,
           showWarnings = FALSE)

# Save the regression diagnostics as a PDF
pdf("outputs/week02/summer_regression_diagnostics.pdf",
    width = 10, height = 8)

par(mfrow = c(2, 2))
plot(minutes_model)

# Close the PDF file
dev.off()

# Reset the plotting layout
par(mfrow = c(1, 1))

# SECTION 8 - Summer's allocated Week 2 task
# Explore injury rates by player characteristics

# Check that injury status is coded as 0 or 1
table(player_data$injured)

# Create a separate dataset for injury analysis
injury_data <- player_data

# Ensure the injury variable is numeric
injury_data$injured <- as.numeric(
  as.character(injury_data$injured)
)

# Check the injury coding
stopifnot(all(
  is.na(injury_data$injured) |
    injury_data$injured %in% c(0, 1)
))

# Overall injury rate as a percentage
100 * mean(injury_data$injured, na.rm = TRUE)


# 1. Injury rates by age

# Group players into age categories
injury_data$age_group <- cut(
  injury_data$age,
  breaks = c(-Inf, 22, 27, 32, Inf),
  labels = c("22 or under", "23-27",
             "28-32", "33+")
)

# Calculate injury percentage in each age group
age_rates <- aggregate(
  injured ~ age_group,
  data = injury_data,
  FUN = function(x) 100 * mean(x)
)

print(age_rates)


# 2. Injury rates by training load

training_rates <- aggregate(
  injured ~ training_load,
  data = injury_data,
  FUN = function(x) 100 * mean(x)
)

print(training_rates)


# 3. Injury rates by previous injuries

previous_rates <- aggregate(
  injured ~ prev_injuries,
  data = injury_data,
  FUN = function(x) 100 * mean(x)
)

print(previous_rates)


# 4. Injury rates by playing position

position_rates <- aggregate(
  injured ~ position,
  data = injury_data,
  FUN = function(x) 100 * mean(x)
)

print(position_rates)


# 5. Injury rates by team

team_rates <- aggregate(
  injured ~ team,
  data = injury_data,
  FUN = function(x) 100 * mean(x)
)

print(team_rates)

# Check how many players each team has
table(injury_data$team)


# SECTION 9 - Plotting injury rates

# Bar chart: injury rate by training load
barplot(
  training_rates$injured,
  names.arg = training_rates$training_load,
  main = "Injury Rate by Training Load",
  xlab = "Training Load",
  ylab = "Injured Players (%)",
  col = "lightblue",
  ylim = c(0, 100)
)

# Bar chart: injury rate by age group
barplot(
  age_rates$injured,
  names.arg = age_rates$age_group,
  main = "Injury Rate by Age Group",
  xlab = "Age Group",
  ylab = "Injured Players (%)",
  col = "lightgreen",
  ylim = c(0, 100)
)

# Bar chart: injury rate by previous injuries
barplot(
  previous_rates$injured,
  names.arg = previous_rates$prev_injuries,
  main = "Injury Rate by Previous Injuries",
  xlab = "Number of Previous Injuries",
  ylab = "Injured Players (%)",
  col = "lightblue",
  ylim = c(0, 100)
)

# Bar chart: injury rate by position
barplot(
  position_rates$injured,
  names.arg = position_rates$position,
  main = "Injury Rate by Playing Position",
  xlab = "Position",
  ylab = "Injured Players (%)",
  col = "lightgreen",
  ylim = c(0, 100)
)


# Bar chart: injury rate by team

# Create the output folder if needed
dir.create("outputs/week02",
           recursive = TRUE,
           showWarnings = FALSE)

# Save the graph as a PNG image
png("outputs/week02/summer_injury_rate_by_team.png",
    width = 1400,
    height = 1100,
    res = 130)

# Make space for the 24 team names
par(mar = c(5, 12, 4, 2))

# Draw the injury-rate graph
barplot(
  team_rates$injured,
  names.arg = team_rates$team,
  main = "Injury Rate by Team",
  xlab = "Injured Players (%)",
  horiz = TRUE,
  las = 1,
  cex.names = 0.65,
  col = "lightblue",
  xlim = c(0, 100)
)

# Finish saving the image
dev.off()

# Restore normal plot margins
par(mar = c(5, 4, 4, 2))

