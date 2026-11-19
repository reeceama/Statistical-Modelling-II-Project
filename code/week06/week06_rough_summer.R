# Week 06 — Poisson regression
# Rough exploratory work: Summer
# Keep everything; move good work into week06_final.R.
# Save outputs to outputs/week06/ with your name in the file name.

source("code/setup.R")
# SECTION 1 - Summer's Week 6 task
# Poisson regression diagnostics

# Aim:
# Investigate goodness of fit and overdispersion
# for the number of goals scored by Ashford United.

# Examine the match dataset
head(match_data)
str(match_data)
dim(match_data)

# Prepare the variables
goals_data <- match_data[, c(
  "goals_scored",
  "home_away",
  "opponent_rank"
)]

# Remove observations with missing values
goals_data <- na.omit(goals_data)

# Home/away is a categorical variable
goals_data$home_away <- factor(
  goals_data$home_away
)

# Check the goal counts
summary(goals_data$goals_scored)
table(goals_data$goals_scored)


# SECTION 2 - Fit the Poisson regression model

# Provisional model from the Week 6 plan

poisson_model <- glm(
  goals_scored ~ home_away + opponent_rank,
  data = goals_data,
  family = poisson(link = "log")
)

# Display the fitted model
summary(poisson_model)


# SECTION 3 - Goodness of fit

# Calculate residual deviance
residual_deviance <- deviance(poisson_model)

# Calculate residual degrees of freedom
residual_df <- df.residual(poisson_model)

# Calculate deviance divided by df
deviance_ratio <- residual_deviance / residual_df

# Display the results
residual_deviance
residual_df
deviance_ratio

# Calculate Pearson dispersion ratio
pearson_ratio <- sum(
  residuals(poisson_model, type = "pearson")^2
) / residual_df

# Display Pearson dispersion
pearson_ratio


# SECTION 4 - Quasi-Poisson comparison

# Fit the same formula using quasi-Poisson
quasi_model <- glm(
  goals_scored ~ home_away + opponent_rank,
  data = goals_data,
  family = quasipoisson(link = "log")
)

# Display quasi-Poisson results
summary(quasi_model)

# Compare coefficient estimates and standard errors
model_comparison <- data.frame(
  Predictor = names(coef(poisson_model)),
  Poisson_Estimate = as.numeric(coef(poisson_model)),
  Poisson_SE = sqrt(diag(vcov(poisson_model))),
  Quasi_Estimate = as.numeric(coef(quasi_model)),
  Quasi_SE = sqrt(diag(vcov(quasi_model)))
)

print(model_comparison)

# SECTION 5 - Interpretation of overdispersion

# The Poisson regression model was fitted
# to goals_scored using home_away and opponent_rank.

# The residual deviance was 49.7845,
# with 43 residual degrees of freedom.

# The deviance divided by degrees of freedom
# was approximately 1.1578.

# This value is slightly above 1 but does not
# suggest substantial overdispersion on its own.

# The Pearson dispersion ratio was 0.9904,
# which is very close to 1.

# The quasi-Poisson model estimated a
# dispersion parameter of approximately 0.9904.

# The Poisson and quasi-Poisson models produced
# identical coefficient estimates.

# Their standard errors were also very similar.

# Therefore, there is no substantial evidence
# of overdispersion from these diagnostics.

# A standard Poisson regression appears
# reasonable for this provisional analysis.

# These diagnostics do not guarantee that
# all model assumptions are satisfied.

# The model should be checked against the
# group's agreed Week 6 model.

# SECTION 6 - Save Week 6 results

# Create the output folder
dir.create(
  "outputs/week06",
  recursive = TRUE,
  showWarnings = FALSE
)

# Save the Poisson and quasi-Poisson comparison
write.csv(
  model_comparison,
  "outputs/week06/summer_poisson_comparison.csv",
  row.names = FALSE
)

# Create a table of goodness-of-fit diagnostics
dispersion_results <- data.frame(
  Diagnostic = c(
    "Residual deviance",
    "Residual degrees of freedom",
    "Deviance divided by df",
    "Pearson dispersion"
  ),
  Value = c(
    residual_deviance,
    residual_df,
    deviance_ratio,
    pearson_ratio
  )
)

# Display the diagnostic results
print(dispersion_results)

# Save the diagnostic table
write.csv(
  dispersion_results,
  "outputs/week06/summer_dispersion_results.csv",
  row.names = FALSE
)

