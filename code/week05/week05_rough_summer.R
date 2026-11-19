# Week 05 — Residuals and diagnostics
# Rough exploratory work: Summer
# Keep everything; move good work into week05_final.R.
# Save outputs to outputs/week05/ with your name in the file name.

source("code/setup.R")


# SECTION 1 - Summer's Week 5 task
# Leverage and Cook's distance

# Aim:
# Identify potentially influential observations
# in logistic and linear regression models.


# SECTION 2 - Fit models for comparison

# Provisional Week 4 logistic regression model
logistic_model <- glm(
  injured ~ age + training_load + prev_injuries,
  data = player_data,
  family = binomial(link = "logit")
)


# Group's agreed Week 2 final linear model
# Predictors retained: training load and position

linear_model <- lm(
  minutes_played ~ training_load + position,
  data = player_data
)

# Check the fitted model
summary(linear_model)



# SECTION 3 - Logistic regression influence

# Calculate leverage
logistic_leverage <- hatvalues(logistic_model)

# Calculate Cook's distance
logistic_cooks <- cooks.distance(logistic_model)

# Summarise the measures
summary(logistic_leverage)
summary(logistic_cooks)

# Create a table for every observation
logistic_influence <- data.frame(
  Player_Row = rownames(model.frame(logistic_model)),
  Leverage = logistic_leverage,
  Cooks_Distance = logistic_cooks
)

# Show the five observations with largest
# Cook's distances
head(
  logistic_influence[
    order(-logistic_influence$Cooks_Distance),
  ],
  5
)


# SECTION 4 - Linear regression influence

# Calculate leverage
linear_leverage <- hatvalues(linear_model)

# Calculate Cook's distance
linear_cooks <- cooks.distance(linear_model)

# Summarise the measures
summary(linear_leverage)
summary(linear_cooks)

# Create a table for every observation
linear_influence <- data.frame(
  Player_Row = rownames(model.frame(linear_model)),
  Leverage = linear_leverage,
  Cooks_Distance = linear_cooks
)

# Show five observations with largest
# Cook's distances
head(
  linear_influence[
    order(-linear_influence$Cooks_Distance),
  ],
  5
)


# SECTION 5 - Flag potentially influential players

# These thresholds are screening guidelines,
# not automatic rules for removing observations.

# Number of observations and parameters
n_logistic <- nobs(logistic_model)
p_logistic <- length(coef(logistic_model))

n_linear <- nobs(linear_model)
p_linear <- length(coef(linear_model))

# Count observations exceeding Cook's D = 4/n
sum(logistic_cooks > 4 / n_logistic)

sum(linear_cooks > 4 / n_linear)

# Count observations with leverage above 2p/n
sum(logistic_leverage > 2 * p_logistic / n_logistic)

sum(linear_leverage > 2 * p_linear / n_linear)


# SECTION 6 - Save influence plots

# Create output folder
dir.create(
  "outputs/week05",
  recursive = TRUE,
  showWarnings = FALSE
)

# Save logistic Cook's distance plot
png(
  "outputs/week05/summer_logistic_cooks.png",
  width = 1200,
  height = 800,
  res = 120
)

plot(
  logistic_cooks,
  type = "h",
  main = "Cook's Distance - Logistic Regression",
  xlab = "Observation Index",
  ylab = "Cook's Distance",
  col = "steelblue"
)

abline(h = 4 / n_logistic,
       col = "red", lty = 2)

dev.off()


# Save linear Cook's distance plot
png(
  "outputs/week05/summer_linear_cooks.png",
  width = 1200,
  height = 800,
  res = 120
)

plot(
  linear_cooks,
  type = "h",
  main = "Cook's Distance - Linear Regression",
  xlab = "Observation Index",
  ylab = "Cook's Distance",
  col = "steelblue"
)

abline(h = 4 / n_linear,
       col = "red", lty = 2)

dev.off()


# SECTION 7 - Save influence tables

write.csv(
  logistic_influence,
  "outputs/week05/summer_logistic_influence.csv",
  row.names = FALSE
)

write.csv(
  linear_influence,
  "outputs/week05/summer_linear_influence.csv",
  row.names = FALSE
)

# SECTION 8 - Interpretation of influence diagnostics

# Leverage and Cook's distance were calculated
# for both logistic and linear regression models.

# In the logistic model, 51 observations exceeded
# the Cook's distance screening threshold of 4/n.

# In the linear model, 29 observations exceeded
# the same type of screening threshold.

# The logistic model identified 54 observations
# with leverage above 2p/n.

# The linear model identified 60 observations
# with leverage above 2p/n.

# The five observations with the largest Cook's
# distances differed between the two models.

# This suggests that observations influential for
# injury risk are not necessarily the same as
# those influential for minutes played.

# The models have different responses and
# explanatory variables, so their influence
# measures are not directly equivalent.

# Exceeding a threshold does not automatically
# mean an observation should be removed.

# Potentially influential observations should
# be investigated further before deciding
# whether any action is necessary.

# These findings are based on provisional models
# and should be checked against the group's
# agreed Week 2 and Week 4 models.


# Updated linear regression results

# The linear model is based on the group's
# agreed Week 2 model:
# minutes_played ~ training_load + position

# The updated linear model identified
# 28 observations exceeding the Cook's
# distance screening threshold of 4/n.

# The updated linear model identified
# 62 observations with leverage above 2p/n.

# The provisional logistic model identified
# 51 observations exceeding the Cook's
# distance screening threshold and
# 54 observations exceeding the leverage threshold.

# Differences between models reflect their
# different responses and predictors.

# Potentially influential observations require
# investigation, not automatic removal.

# The logistic results must still be checked
# against the group's agreed Week 4 model.


# SECTION 9 - Comparison of influential observations

# The corrected linear regression model uses
# training_load and position to explain
# minutes_played.

# The five observations with the largest
# Cook's distances in the linear model are
# rows 531, 43, 297, 466 and 40.

# The five observations with the largest
# Cook's distances in the provisional logistic
# model are rows 238, 281, 546, 169 and 101.

# There is no overlap between the two top-five
# lists of influential observations.

# This indicates that the observations with
# the greatest influence differ between models.

# The updated linear model identified 28
# observations above the Cook's distance
# screening threshold and 62 above the
# leverage screening threshold.

# The provisional logistic model identified
# 51 observations above the Cook's distance
# threshold and 54 above the leverage threshold.

# These are screening results and do not
# justify automatically removing observations.

# The logistic analysis should be reviewed
# once the group's Week 4 model is agreed.

# The logistic regression results are provisional.
# These diagnostics will be checked again once
# the group's Week 4 model is finalised.

