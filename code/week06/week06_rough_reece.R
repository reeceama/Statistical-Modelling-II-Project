# Week 06 — Poisson regression
# Rough exploratory work: Reece
# Keep everything; move good work into week06_final.R.
# Save outputs to outputs/week06/ with your name in the file name.

source("code/setup.R")


# ----- 1. Exploring goals conceded -----

# The number of matches with each number of goals conceded by Ashford (0: 17, 1: 22, 2: 5, 3: 2).
table(match_data$goals_conceded)

# The mean and variance of goals conceded per game (0.826, 0.636).
# The variance is below the mean, so the counts are less spread out than a Poisson model expects.
c(
  mean = mean(match_data$goals_conceded),
  variance = var(match_data$goals_conceded)
)

# Average goals conceded away (1.09) and at home (0.57), so Ashford concede about half as many at home.
tapply(match_data$goals_conceded, match_data$home_away, mean)


# ----- 2. Fitting the model -----

# The same Poisson model as for goals scored, with home/away and opponent rank.
conceded_model <- glm(
  goals_conceded ~ home_away + opponent_rank,
  data = match_data,
  family = poisson
)

summary(conceded_model)


# ----- 3. Checking the terms -----

# Adding the interaction doesn't improve the fit (p = 0.72), so home advantage is the same whatever the opponent's rank.
conceded_int <- update(conceded_model, . ~ . + home_away:opponent_rank)
anova(conceded_model, conceded_int, test = "Chisq")

# Removing either term makes the fit significantly worse (home/away p = 0.050, opponent rank p = 0.027), so both are kept.
drop1(conceded_model, test = "Chisq")


# ----- 4. Rate ratios with 95% confidence intervals -----

# Exponentiating the coefficients gives rate ratios, which multiply the expected goals conceded.
# At home, Ashford concede about half as many goals as away (RR 0.52, 95% CI 0.26 to 1.00).
# Each place lower the opponent ranks reduces goals conceded by about 5% (RR 0.95, 95% CI 0.91 to 0.99).
conceded_rr <- data.frame(
  rate_ratio = exp(coef(conceded_model)),
  lower_95 = exp(confint(conceded_model))[, 1],
  upper_95 = exp(confint(conceded_model))[, 2]
)
round(conceded_rr, 3)

# Per 5 places lower, goals conceded fall by about 23% (RR 0.77, 95% CI 0.61 to 0.97).
round(exp(5 * c(coef(conceded_model)["opponent_rank"], confint(conceded_model)["opponent_rank", ])), 3)

# Saves the rate ratio table rounded to 3 decimal places.
write.csv(round(conceded_rr, 3), "outputs/week06/reece_conceded_rate_ratios.csv")


# ----- 5. Fit and dispersion -----

# The residual deviance is 32.8 on 43 df (p = 0.87), so there's no evidence of poor fit.
deviance(conceded_model)
df.residual(conceded_model)
pchisq(deviance(conceded_model), df.residual(conceded_model), lower.tail = FALSE)

# The Pearson dispersion is 0.57, well below 1, so goals conceded are underdispersed.
sum(residuals(conceded_model, type = "pearson")^2) / df.residual(conceded_model)

# A quasi-Poisson model allows for this, and gives smaller standard errors and the same estimates.
# Home/away becomes clearly significant (p = 0.016), so the Poisson p-values and intervals are on the cautious side.
conceded_quasi <- update(conceded_model, family = quasipoisson)
summary(conceded_quasi)

# Standard errors from both models. Quasi-Poisson multiplies them by the square root of the dispersion (0.76), so they shrink by about a quarter.
round(cbind(
  poisson_se = sqrt(diag(vcov(conceded_model))),
  quasi_se = sqrt(diag(vcov(conceded_quasi)))
), 4)


# ----- 6. Conclusion -----

# Ashford concede about half as many goals at home, and fewer against weaker opponents.
# This mirrors goals scored, where they score about twice as many at home and more against weaker opponents.
# Goals conceded are underdispersed, so the Poisson intervals are wider than they need to be.
