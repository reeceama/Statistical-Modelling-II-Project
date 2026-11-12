# Week 03 — Introduction to GLMs
# Rough exploratory work: Reece
# Keep everything; move good work into week03_final.R.
# Save outputs to outputs/week03/ with your name in the file name.

source("code/setup.R")


# ----- 1. Refitting -----

# The final linear model I decided on in week 2.
final_lm <- lm(
  minutes_played ~ 
    training_load + 
    position, 
  data = player_data
  )

# The same model refitted as a GLM. A GLM with a normal (gaussian) distribution and identity link
# should be exactly the same as linear regression, so the results should match the lm.
final_glm <- glm(
  minutes_played ~ 
    training_load + 
    position, 
  data = player_data,
  family = gaussian
  )

# The residual deviance (224,673,378) is the same as the lm's RSS, and the AIC is the same (9707.8).
# The null deviance is the total variation with no predictors, so (null - residual) / null = 0.28, the same R^2 as the lm.
# Linear regression is a GLM with a normal distribution and identity link, and the deviance, dispersion and AIC shown here also work for other GLM's, where R^2 doesn't apply.
summary(final_glm)
# The coefficients, standard errors and p-values are exactly the same in both models.
# The dispersion (365,322.6) is the error variance, equal to the lm's residual SE squared (604.4^2).
cbind(lm = coef(final_lm), glm = coef(final_glm))


# ----- 2. Is a normal distribution suitable? -----

# A gaussian GLM assumes the errors are roughly normal, so I check the shape of minutes played.
summary(player_data$minutes_played)
# The distribution is roughly symmetric, peaking around 2250-2750, with mean (2540) and median (2544) almost equal.
# There is a slightly longer tail on the left, and a hard upper limit (max 3960, out of a possible 4140).
hist(player_data$minutes_played,
     breaks = seq(0, 4000, by = 250),
     main = "Distribution of minutes played",
     xlab = "Minutes played over the season",
     xaxt = "n")
axis(1, at = seq(0, 4000, by = 250), labels = FALSE)
axis(1, at = seq(0, 4000, by = 500))

dev.copy(png, "outputs/week03/reece_mins_histogram.png", width = 900, height = 600, res = 120)
dev.off()


# ----- 3. Conclusion -----

# Minutes played is continuous and roughly symmetric, so a normal GLM with identity link suits it.
# The GLM gives exactly the same estimates as my week 2 linear model, so the week 2 results still hold as a GLM.
# The histogram suggests normality is reasonable, but the assumption is really about the residuals, so it still needs checking with residual plots.