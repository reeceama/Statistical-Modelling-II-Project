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
