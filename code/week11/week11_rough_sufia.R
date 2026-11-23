# Week 11 — Generalised linear mixed models
# Rough exploratory work: Sufia

source("code/setup.R")
library(lme4)

# ---- Sufia: 2. random team intercept vs fixed effects for injured ----

glm_model <- glm(injured ~ age + training_load + prev_injuries,
                 family = binomial, data = player_data)

glmm_model <- glmer(injured ~ age + training_load + prev_injuries + (1 | team),
                    family = binomial, data = player_data)
summary(glmm_model)
isSingular(glmm_model)

VarCorr(glmm_model)
team_var <- as.data.frame(VarCorr(glmm_model))$vcov
team_var
team_var / (team_var + pi^2 / 3)

fixed_team <- glm(injured ~ age + training_load + prev_injuries + team,
                  family = binomial, data = player_data)
anova(glm_model, fixed_team, test = "Chisq")

or_table <- data.frame(
  glm             = exp(coef(glm_model)),
  glmm            = exp(fixef(glmm_model)),
  fixed_team      = exp(coef(fixed_team))[1:4]
)
round(or_table, 3)
write.csv(round(or_table, 3), "outputs/week11/sufia_odds_ratios_glm_vs_glmm.csv")

ci_compare <- data.frame(
  glm_lower  = exp(confint.default(glm_model))[, 1],
  glm_upper  = exp(confint.default(glm_model))[, 2],
  glmm_lower = exp(confint(glmm_model, method = "Wald"))[-1, 1],
  glmm_upper = exp(confint(glmm_model, method = "Wald"))[-1, 2]
)
round(ci_compare, 3)

aic_table <- data.frame(
  model = c("GLM (no team)", "GLMM (random team intercept)", "GLM (team as fixed effect)"),
  AIC   = round(c(AIC(glm_model), AIC(glmm_model), AIC(fixed_team)), 2)
)
aic_table
write.csv(aic_table, "outputs/week11/sufia_aic_comparison.csv", row.names = FALSE)

lrt_stat <- as.numeric(2 * (logLik(glmm_model) - logLik(glm_model)))
lrt_stat
0.5 * pchisq(lrt_stat, df = 1, lower.tail = FALSE)

# Overview
# Compared the week 4 injury model with a version adding a random team intercept.
# The between team variance is estimated as 0 ("boundary (singular) fit").
# So the mixed model gives the same results as the ordinary logistic model:
# age OR 1.11, training load OR 1.38, previous injuries OR 1.67, same CIs.
# LRT for the team variance is about 0 (p = 0.5).
# Team as 23 fixed effects doesn't help either: LRT 20.9 on 23 df, p = 0.59.
# AIC: GLM 547.3, GLMM 549.3, fixed team 572.4, so the plain GLM is best.
# Conclusions don't change: injury risk doesn't vary between teams (as in weeks 3 and 8).
