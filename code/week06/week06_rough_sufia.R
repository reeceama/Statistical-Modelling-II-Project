# Week 06 — Poisson regression
# Rough exploratory work: Sufia

source("code/setup.R")

# ---- Sufia: 3. interpretation: rate ratios with 95% CIs ----

levels(match_data$home_away)

goals_model <- glm(
  goals_scored ~ home_away + opponent_rank,
  data = match_data,
  family = poisson(link = "log")
)
summary(goals_model)

goals_int <- update(goals_model, . ~ . + home_away:opponent_rank)
anova(goals_model, goals_int, test = "Chisq")

rate_ratios <- data.frame(
  rate_ratio = exp(coef(goals_model)),
  lower_95   = exp(confint.default(goals_model))[, 1],
  upper_95   = exp(confint.default(goals_model))[, 2],
  p_value    = summary(goals_model)$coefficients[, 4]
)
round(rate_ratios, 3)
write.csv(round(rate_ratios, 3), "outputs/week06/sufia_goals_rate_ratios.csv")
exp(confint(goals_model))

rr_5 <- exp(5 * coef(goals_model)["opponent_rank"])
ci_5 <- exp(5 * confint.default(goals_model)["opponent_rank", ])
round(c(rate_ratio = unname(rr_5), lower_95 = ci_5[1], upper_95 = ci_5[2]), 3)

new_matches <- expand.grid(
  home_away     = c("Home", "Away"),
  opponent_rank = c(1, 12, 24)
)
pred <- predict(goals_model, newdata = new_matches, type = "link", se.fit = TRUE)
new_matches$expected_goals <- round(exp(pred$fit), 2)
new_matches$lower_95 <- round(exp(pred$fit - 1.96 * pred$se.fit), 2)
new_matches$upper_95 <- round(exp(pred$fit + 1.96 * pred$se.fit), 2)
new_matches
write.csv(new_matches, "outputs/week06/sufia_goals_predictions.csv", row.names = FALSE)

rank_grid <- 1:24
plot(match_data$opponent_rank, match_data$goals_scored,
     pch = ifelse(match_data$home_away == "Home", 16, 1),
     col = ifelse(match_data$home_away == "Home", "darkblue", "darkorange"),
     xlab = "Opponent rank (1 = strongest)", ylab = "Goals scored by Ashford",
     main = "Expected goals by opponent rank")
lines(rank_grid, predict(goals_model, data.frame(home_away = "Home", opponent_rank = rank_grid),
                         type = "response"), col = "darkblue", lwd = 2)
lines(rank_grid, predict(goals_model, data.frame(home_away = "Away", opponent_rank = rank_grid),
                         type = "response"), col = "darkorange", lwd = 2, lty = 2)
legend("topleft", legend = c("Home", "Away"), col = c("darkblue", "darkorange"),
       pch = c(16, 1), lty = c(1, 2), lwd = 2, bty = "n")
dev.copy(png, "outputs/week06/sufia_expected_goals.png", width = 900, height = 600, res = 120)
dev.off()

sum(residuals(goals_model, type = "pearson")^2) / df.residual(goals_model)

# Main effects model, as the interaction isn't significant (p = 0.55). Holding opponent rank fixed,
# Ashford score about twice as many goals at home as away (RR 2.00, 95% CI 1.17 to 3.42). Each place
# lower the opponent sits multiplies expected goals by 1.056 (95% CI 1.016 to 1.097), about 31% more per
# 5 places (95% CI 9% to 59%). Predicted goals go from about 0.43 away at the top team to about 3.0 at home
# against the bottom team. Pearson/df is about 0.99, so no sign of overdispersion, but with 46 matches
# (and the 8 goal home win against the bottom team) the CIs are wide.
