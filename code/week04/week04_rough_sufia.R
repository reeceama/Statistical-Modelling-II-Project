# Week 04 — Binomial regression
# Rough exploratory work: Sufia

source("code/setup.R")

# ---- Sufia: 1. full logistic model for injured ----

table(player_data$injured)
mean(player_data$injured)

round(tapply(player_data$injured, player_data$training_load, mean), 3)
round(tapply(player_data$injured, player_data$prev_injuries, mean), 3)
round(tapply(player_data$injured, player_data$position, mean), 3)
round(tapply(player_data$injured, cut(player_data$age, c(16, 21, 25, 29, 36)), mean), 3)

full_logit <- glm(
  injured ~ age + training_load + prev_injuries + bmi + position,
  data = player_data,
  family = binomial(link = "logit")
)
summary(full_logit)

full_or <- data.frame(
  odds_ratio = exp(coef(full_logit)),
  lower_95   = exp(confint.default(full_logit))[, 1],
  upper_95   = exp(confint.default(full_logit))[, 2]
)
round(full_or, 3)
write.csv(round(full_or, 3), "outputs/week04/sufia_full_model_odds_ratios.csv")

null_logit <- glm(injured ~ 1, data = player_data, family = binomial)
anova(null_logit, full_logit, test = "Chisq")

drop1(full_logit, test = "Chisq")

# Overview
# injured is binary (19% injured), so a binomial GLM with logit link suits it.
# All five player variables included; team left out (week 3: no clear team effect).
# Training load kept numeric, as the group agreed.
# Full model beats the null model: deviance 594.7 to 536.2, p < 0.001 (AIC 552.2).
# Age (OR 1.11, p < 0.001), training load (OR 1.35, p = 0.007) and
# previous injuries (OR 1.66, p < 0.001) all raise injury risk.
# BMI (p = 0.58) and position (p = 0.45) look droppable: see section 2
