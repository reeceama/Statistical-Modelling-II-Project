# Week 05 — Residuals and diagnostics
# Rough exploratory work: Sufia

source("code/setup.R")

# ---- Sufia: 2. logistic model diagnostics ----

injury_model <- glm(
  injured ~ age + training_load + prev_injuries,
  data = player_data,
  family = binomial
)
summary(injury_model)

fitted_p <- fitted(injury_model)
summary(fitted_p)

dev_res  <- residuals(injury_model, type = "deviance")
pear_res <- residuals(injury_model, type = "pearson")
summary(dev_res)
summary(pear_res)
sum(dev_res^2)
sum(pear_res^2)
sum(abs(dev_res) > 2)
sum(abs(pear_res) > 2)

par(mfrow = c(1, 2))
plot(fitted_p, dev_res,
     col = ifelse(player_data$injured == 1, "red", "grey40"), pch = 16, cex = 0.7,
     xlab = "Fitted probability of injury", ylab = "Deviance residual",
     main = "Deviance residuals")
abline(h = c(-2, 0, 2), lty = c(2, 1, 2))
plot(fitted_p, pear_res,
     col = ifelse(player_data$injured == 1, "red", "grey40"), pch = 16, cex = 0.7,
     xlab = "Fitted probability of injury", ylab = "Pearson residual",
     main = "Pearson residuals")
abline(h = c(-2, 0, 2), lty = c(2, 1, 2))
legend("topright", legend = c("Injured", "Not injured"),
       col = c("red", "grey40"), pch = 16, cex = 0.7, bty = "n")
dev.copy(png, "outputs/week05/sufia_logistic_residuals.png", width = 1100, height = 550, res = 120)
dev.off()
par(mfrow = c(1, 1))

raw_res <- player_data$injured - fitted_p
bin <- cut(rank(fitted_p, ties.method = "first"), breaks = 20, labels = FALSE)
binned <- data.frame(
  n           = as.numeric(tapply(raw_res, bin, length)),
  mean_fitted = as.numeric(tapply(fitted_p, bin, mean)),
  observed    = as.numeric(tapply(player_data$injured, bin, mean)),
  mean_resid  = as.numeric(tapply(raw_res, bin, mean))
)
binned$se_band <- 2 * sqrt(as.numeric(tapply(fitted_p * (1 - fitted_p), bin, sum))) / binned$n
round(binned, 3)
write.csv(round(binned, 3), "outputs/week05/sufia_binned_residuals.csv", row.names = FALSE)

plot(binned$mean_fitted, binned$mean_resid,
     pch = 16, ylim = range(c(-binned$se_band, binned$se_band, binned$mean_resid)),
     xlab = "Average fitted probability (bin)", ylab = "Average residual (bin)",
     main = "Binned residual plot: injury model")
lines(binned$mean_fitted,  binned$se_band, lty = 2, col = "grey40")
lines(binned$mean_fitted, -binned$se_band, lty = 2, col = "grey40")
abline(h = 0)
dev.copy(png, "outputs/week05/sufia_binned_residual_plot.png", width = 900, height = 600, res = 120)
dev.off()
sum(abs(binned$mean_resid) > binned$se_band)

binned_by <- function(x, label) {
  b    <- cut(rank(x, ties.method = "first"), breaks = 10, labels = FALSE)
  mx   <- tapply(x, b, mean)
  mr   <- tapply(raw_res, b, mean)
  band <- 2 * sqrt(tapply(fitted_p * (1 - fitted_p), b, sum)) / tapply(raw_res, b, length)
  plot(mx, mr, pch = 16, ylim = range(c(-band, band, mr)),
       xlab = label, ylab = "Average residual", main = label)
  lines(mx, band, lty = 2, col = "grey40")
  lines(mx, -band, lty = 2, col = "grey40")
  abline(h = 0)
}
par(mfrow = c(1, 3))
binned_by(player_data$age, "Age")
binned_by(player_data$training_load, "Training load")
binned_by(player_data$prev_injuries, "Previous injuries")
dev.copy(png, "outputs/week05/sufia_binned_residuals_by_predictor.png", width = 1200, height = 450, res = 120)
dev.off()
par(mfrow = c(1, 1))

dec <- cut(rank(fitted_p, ties.method = "first"), breaks = 10, labels = FALSE)
hl_table <- data.frame(
  n        = as.numeric(tapply(player_data$injured, dec, length)),
  observed = as.numeric(tapply(player_data$injured, dec, sum)),
  expected = as.numeric(tapply(fitted_p, dec, sum))
)
round(hl_table, 2)
hl_stat <- sum((hl_table$observed - hl_table$expected)^2 /
                 (hl_table$expected * (1 - hl_table$expected / hl_table$n)))
hl_stat
pchisq(hl_stat, df = 8, lower.tail = FALSE)

# Overview
# Checked the agreed week 4 model: age, training load, previous injuries.
# Residuals form two bands, which is normal for a binary response.
# Large residuals (26 deviance, 50 Pearson above 2) are injured players
# the model gave a low risk to; expected, not a problem.
# Binned residual plot: 1 of 20 bins outside the bands (the lowest risk bin)
# Grouped goodness of fit: about 17.3 on 8 df, p about 0.03 (borderline)
# The model underestimates risk for the lowest and highest risk players
