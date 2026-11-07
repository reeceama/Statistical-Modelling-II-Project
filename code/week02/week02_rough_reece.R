# Week 02 — Exploration and normal linear regression
# Rough exploratory work: Reece
# Keep everything; move good work into week02_final.R.
# Save outputs to outputs/week02/ with your name in the file name.

source("code/setup.R")
library(modelsummary)

# ----- 1. Data loading ------

# Check the structure of the player data.
str(player_data)
summary(player_data)

# ----- 2. Full model -----

# GK is used as the reference position to remain consistent with other files.
player_data$position <- relevel(player_data$position, ref = "GK")

# A linear model is used to see how each variable affects player minutes. We start with all five as we are currently unsure which have the biggest impact.
full_model <- lm(
  minutes_played ~ 
    age + 
    training_load + 
    prev_injuries + 
    position + 
    bmi,
  data = player_data)

# The summary shows that position and training load are the most impactful variables.
summary(full_model)

# ----- 3. Backward elimination -----

# drop1 tests the full model with each term removed sequentially, using an F test to see how the fit changes.
# I remove the term with the largest p-value if it is > 0.05, and stop when all remaining terms have p < 0.05
drop1(full_model, test = "F")

# Round 1: I start by dropping age, as it has the highest p-value (0.815). 
# The higher the p-value, the weaker the evidence that the variable matters.
# Age reduces error by 20014 out of 224 million, and p = 0.815 means that even if age had no effect, you'd see an improvement this big at least 81.5% of the time.
# Therefore, the age variable is largely just noise, and has no significant impact on the model.
model_a <- update(full_model, . ~ . - age)
drop1(model_a, test = "F")

# Round 2: remove bmi, with p = 0.749.
model_b <- update(model_a, . ~ . - bmi)
drop1(model_b, test = "F")

# Round 3: remove prev_injuries, with p = 0.535.
model_c <- update(model_b, . ~ . - prev_injuries)
drop1(model_c, test = "F")

# Round 4: as the final two variables have p < 0.05, we keep them and build the final model.
final_model <- model_c
# The three dropped terms are not needed together. F(3, 612) = 0.18, p = 0.91.
# F = 0.18 means adding all 3 back barely changes the fit, and p > 0.05 means there's no evidence for their usefulness.
anova(final_model, full_model)
# AIC compares models by rewarding good fit but penalising extra variables, where lower is better.
# The final model has a lower AIC (9707.8 vs 9713.2), so the simpler model is preferred.
AIC(full_model, final_model)

# ----- 4. Training load check -----

# Training load is a 1-5 rating, so I check whether it works better as categories than as a number.
# F(3, 612) = 0.40, p = 0.75, so categories don't improve the fit, and keeping it as a number is justified.
cat_model <- update(final_model, . ~ . - training_load + factor(training_load))
anova(final_model, cat_model)

# ----- 5. Results -----

# The final model keeps training load and position, with 95% confidence intervals for each effect.
# Each one-level increase in training load is linked to about 144 more minutes (95% CI 96 to 191).
# Compared with goalkeepers, defenders play about 578 fewer minutes, midfielders 900 fewer and forwards 1200 fewer.
# R^2 = 0.28, so the model explains 28% of the variation in minutes, and the rest is due to factors not in the data.
summary(final_model)
confint(final_model)

# This table compares the full and final models side by side, and saves it to outputs.
# The kept estimates barely change, so removing the three variables doesn't change the conclusions.
# Adjusted R^2 rises and AIC falls, so the simpler final model is preferred.
modelsummary(
  list("Full model" = full_model, "Final model" = final_model),
  statistic = "conf.int",
  stars = TRUE,
  gof_map = c("nobs", "r.squared", "adj.r.squared", "aic"),
  fmt = 1,
  output = "outputs/week02/reece_model_comparison.html"
)

browseURL("outputs/week02/reece_model_comparison.html")
