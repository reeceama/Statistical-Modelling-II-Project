# Week 04 — Binomial regression
# Rough exploratory work: Summer
# Keep everything; move good work into week04_final.R.
# Save outputs to outputs/week04/ with your name in the file name.

source("code/setup.R")
# SECTION 1 - Summer's Week 4 model selection
# Investigating which predictors of injury to retain

# Check the injury outcome
table(player_data$injured)

# Prepare the variables for the model
injury_data <- player_data[, c(
  "injured", "age", "training_load",
  "prev_injuries", "bmi", "position"
)]

# Use complete observations for model comparisons
injury_data <- na.omit(injury_data)

# Make sure injured is coded as 0 or 1
injury_data$injured <- as.integer(
  as.character(injury_data$injured)
)

stopifnot(all(injury_data$injured %in% c(0, 1)))

# Treat playing position as categorical
injury_data$position <- factor(injury_data$position)


# SECTION 2 - Fit a provisional full logistic model

# This model is for initial comparison.
# Confirm the agreed full model with Sufia.

full_model <- glm(
  injured ~ age + training_load +
    prev_injuries + bmi + position,
  data = injury_data,
  family = binomial(link = "logit")
)

# Examine the full model
summary(full_model)


# SECTION 3 - Likelihood ratio tests

# Test the effect of removing each predictor
# from the full model, one at a time

drop1(full_model, test = "Chisq")


# SECTION 4 - Compare models using AIC

# Find the AIC of the full model
AIC(full_model)

# Example: compare with a model without BMI
reduced_model <- update(
  full_model,
  . ~ . - bmi
)

# Compare the two AIC values
AIC(full_model, reduced_model)

# Compare the nested models using an LRT
anova(
  reduced_model,
  full_model,
  test = "Chisq"
)

# NOTE:
# Removing BMI here is only an example.
# Decide which predictors to retain after
# examining the likelihood ratio tests,
# AIC values and statistical reasoning.


# SECTION 5 - Compare simpler logistic models

# Remove position from the full model
model_no_position <- update(
  full_model,
  . ~ . - position
)

# Remove BMI as well
model_no_position_bmi <- update(
  model_no_position,
  . ~ . - bmi
)

# Compare AIC values for all three models
AIC(
  full_model,
  model_no_position,
  model_no_position_bmi
)

# Likelihood ratio test:
# Does removing position and BMI together
# significantly worsen the model?

anova(
  model_no_position_bmi,
  full_model,
  test = "Chisq"
)

# Check the remaining predictor contributions
drop1(
  model_no_position_bmi,
  test = "Chisq"
)

# Display the simpler model
summary(model_no_position_bmi)


# SECTION 6 - Interpretation of model selection

# Three logistic regression models were compared
# using AIC and likelihood ratio tests.

# The full model included age, training_load,
# prev_injuries, bmi and position.

# The full model had an AIC of 552.23.

# Removing position reduced the AIC to 548.86.

# Removing both position and bmi further
# reduced the AIC to 547.27.

# The likelihood ratio test comparing the
# reduced and full models gave p = 0.5505.

# Since p > 0.05, there is insufficient
# evidence that removing BMI and position
# significantly worsens model fit.

# The reduced model has the lowest AIC of
# the three models compared.

# Therefore, the provisional preferred model
# retains age, training_load and prev_injuries.

# This choice should be checked against the
# agreed full model fitted by Sufia.

# Model selection does not establish causation
# or prove that excluded variables have no effect.


# SECTION 8 - Save model comparison results

# Create the Week 4 output folder
dir.create(
  "outputs/week04",
  recursive = TRUE,
  showWarnings = FALSE
)

# Create a table comparing model AIC values
model_comparison <- data.frame(
  Model = c(
    "Full model",
    "Without position",
    "Without position and BMI"
  ),
  AIC = c(
    AIC(full_model),
    AIC(model_no_position),
    AIC(model_no_position_bmi)
  )
)

# Display the comparison
print(model_comparison)

# Save the results
write.csv(
  model_comparison,
  "outputs/week04/summer_model_comparison.csv",
  row.names = FALSE
)
