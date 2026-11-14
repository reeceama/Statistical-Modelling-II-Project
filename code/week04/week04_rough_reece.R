# Week 04 — Binomial regression
# Rough exploratory work: Reece
# Keep everything; move good work into week04_final.R.
# Save outputs to outputs/week04/ with your name in the file name.

source("code/setup.R")
 

# ----- 1. Preparing the data -----

# Selects the injury model variables, the same as Summer's.
injury_data <- player_data[, c(
  "injured", 
  "age", 
  "training_load",
  "prev_injuries",
  "bmi",
  "position"
)]

# The number of players in the dataset (620).
nrow(injury_data)
# The distribution of injuries, where 0 = not injured (505) and 1 = injured (115).
table(injury_data$injured)

# ----- 2. Fitting the final model -----

# Summer's final model, where injury depends on age, training load and previous injuries (AIC 547.27).
final_model <- glm(injured ~ 
                     age + 
                     training_load + 
                     prev_injuries,
                   data = injury_data,
                   family = binomial
                   )

summary(final_model)

# ----- 3. Odds ratios with 95% confidence intervals -----

# Converts the coefficients from log-odds to odds ratios, which are easier to interpret.
odds_ratios <- exp(coef(final_model))
# 95% confidence intervals for the coefficients, also converted to odds ratios.
or_ci <- exp(confint(final_model))

# Table of each odds ratio with its 95% confidence interval.
# An odds ratio above 1 means higher odds of injury, below 1 means lower odds, and 1 means no effect.
# If the interval doesn't include 1, the effect is significant at the 5% level.
# Each odds ratio is the effect of one variable with the other two held fixed.
# The intercept isn't interpreted, as it describes a player aged 0 with no training load.
or_table <- data.frame(
  odds_ratio = odds_ratios,
  lower_95 = or_ci[, 1],
  upper_95 = or_ci[, 2]
)
round(or_table, 3)

# Saves the odds ratio table rounded to 3 decimal places.
write.csv(round(or_table, 3), "outputs/week04/reece_odds_ratios.csv")

# ----- 4. Rescaled odds ratios -----

# An odds ratio per year of age is small and hard to picture, so it's also given per 5 years.
# Training load is scored 1 to 5, so going from the lowest to the highest level is 4 steps.
# Multiplying a coefficient before exponentiating gives the effect of that larger change.
rescaled_table <- data.frame(
  odds_ratio = exp(c(5, 4) * coef(final_model)[c("age", "training_load")]),
  lower_95   = exp(c(5, 4) * confint(final_model)[c("age", "training_load"), 1]),
  upper_95   = exp(c(5, 4) * confint(final_model)[c("age", "training_load"), 2]),
  row.names  = c("age (per 5 years)", "training_load (1 to 5)")
)
round(rescaled_table, 3)

# Saves the rescaled odds ratio table rounded to 3 decimal places.
write.csv(round(rescaled_table, 3), "outputs/week04/reece_odds_ratios_rescaled.csv")


# ----- 5. Checking training load as a number -----

# Proportion of players injured at each training load level: 15%, 11%, 16%, 26%, 26%.
round(prop.table(table(injury_data$training_load, injury_data$injured), 1), 3)

# The model treats training load as a number, so every step up has the same effect.
# This refits it as categories, which lets each level have its own effect.
cat_load_model <- glm(injured ~ age + factor(training_load) + prev_injuries,
                      data = injury_data,
                      family = binomial)

# Categories don't fit significantly better (p = 0.24) and have a higher AIC (549.1 vs 547.3),
# so treating training load as a number is justified.
anova(final_model, cat_load_model, test = "Chisq")
AIC(final_model, cat_load_model)


# ----- 6. Conclusion -----

# All three predictors significantly increase the odds of injury, as no 95% CI includes 1.
# Odds of injury rise by about 67% per previous injury (1.40 to 2.00), 38% per training load level (1.11 to 1.71)
# and 69% per 5 years of age (1.28 to 2.26), with the other variables held fixed.
# A player at training load 5 has about 3.6 times the odds of injury of one at load 1 (1.52 to 8.62).
# The training load interval is widest, so the size of that effect is the least certain.