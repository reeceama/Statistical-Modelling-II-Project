# Week 06 — Poisson regression
# Rough exploratory work: Saema
# Keep everything; move good work into week06_final.R.
# Save outputs to outputs/week06/ with your name in the file name.
matches <- read.csv("ashford_matches(1).csv")

head(matches)
str(matches)
summary(matches)

# Convert home_away to a categorical variable
matches$home_away <- factor(
  matches$home_away,
  levels = c("Away", "Home"))

table(matches$home_away)


# 3. Explore the response variable
summary(matches$goals_scored)

mean(matches$goals_scored)
var(matches$goals_scored)

table(matches$goals_scored)

# Plot the distribution of goals scored
hist(
  matches$goals_scored,
  breaks = seq(-0.5, max(matches$goals_scored) + 0.5, 1),
  main = "Distribution of Goals Scored by Ashford United",
  xlab = "Goals scored",
  ylab = "Frequency",
  col = "lightblue")


# 4. Compare goals scored at home and away

boxplot(
  goals_scored ~ home_away,
  data = matches,
  main = "Goals Scored at Home and Away",
  xlab = "Match location",
  ylab = "Goals scored",
  col = c("lightgreen", "lightblue"))

# Calculate mean goals for each location
aggregate(
  goals_scored ~ home_away,
  data = matches,
  FUN = mean)


# 5. Explore the relationship with opponent rank

plot(
  matches$opponent_rank,
  matches$goals_scored,
  main = "Goals Scored Against Opponents of Different Ranks",
  xlab = "Opponent's final league rank",
  ylab = "Goals scored",
  pch = 19)


# 6. Fit a Poisson regression model

model <- glm(
  goals_scored ~ home_away + opponent_rank,
  data = matches,
  family = poisson(link = "log"))

# Model results
summary(model)

# 7. Interpret coefficients using incidence rate ratios

# Exponentiate coefficients
exp(coef(model))

# Confidence intervals for the incidence rate ratios
exp(confint.default(model))


# 8.predicted mean goals

matches$predicted_goals <- predict(
  model,
  type = "response")

# Compare observed and predicted values
head(
  matches[, c(
    "home_away",
    "goals_scored",
    "opponent_rank",
    "predicted_goals" )])

# 9. Check for overdispersion
pearson_residuals <- residuals(
  model,
  type = "pearson")

# Dispersion statistic
dispersion <- sum(pearson_residuals^2) /
  df.residual(model)

dispersion

# 10. Examine model diagnostics

par(mfrow = c(2, 2))
plot(model)
par(mfrow = c(1, 1))


# 11. Compare observed and predicted mean goals by match location

aggregate(
  cbind(goals_scored, predicted_goals) ~ home_away,
  data = matches,
  FUN = mean)
source("code/setup.R")
