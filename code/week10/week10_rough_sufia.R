# Week 10 — Specialised models
# Rough exploratory work: Sufia

source("code/setup.R")
library(MASS)

# ---- Sufia: 1. negative binomial for goals, compared with Poisson ----

c(mean = mean(match_data$goals_scored), variance = var(match_data$goals_scored))
c(mean = mean(match_data$goals_conceded), variance = var(match_data$goals_conceded))

pois_scored <- glm(goals_scored ~ home_away + opponent_rank, family = poisson, data = match_data)
summary(pois_scored)
sum(residuals(pois_scored, type = "pearson")^2) / df.residual(pois_scored)
deviance(pois_scored) / df.residual(pois_scored)

nb_scored <- glm.nb(goals_scored ~ home_away + opponent_rank, data = match_data)
summary(nb_scored)
nb_scored$theta
nb_scored$SE.theta

compare <- data.frame(
  model    = c("Poisson", "Negative binomial"),
  logLik   = round(c(logLik(pois_scored), logLik(nb_scored)), 2),
  AIC      = round(c(AIC(pois_scored), AIC(nb_scored)), 2),
  home_RR  = round(exp(c(coef(pois_scored)[2], coef(nb_scored)[2])), 3),
  rank_RR  = round(exp(c(coef(pois_scored)[3], coef(nb_scored)[3])), 3),
  home_SE  = round(c(sqrt(diag(vcov(pois_scored)))[2], sqrt(diag(vcov(nb_scored)))[2]), 3),
  rank_SE  = round(c(sqrt(diag(vcov(pois_scored)))[3], sqrt(diag(vcov(nb_scored)))[3]), 4)
)
compare
write.csv(compare, "outputs/week10/sufia_poisson_vs_negbin.csv", row.names = FALSE)

lrt_stat <- as.numeric(2 * (logLik(nb_scored) - logLik(pois_scored)))
lrt_stat
0.5 * pchisq(lrt_stat, df = 1, lower.tail = FALSE)

max_goals <- 0:8
mu_p  <- fitted(pois_scored)
mu_nb <- fitted(nb_scored)
obs_freq  <- as.numeric(table(factor(match_data$goals_scored, levels = max_goals)))
pois_freq <- sapply(max_goals, function(k) sum(dpois(k, mu_p)))
nb_freq   <- sapply(max_goals, function(k) sum(dnbinom(k, mu = mu_nb, size = nb_scored$theta)))
round(data.frame(goals = max_goals, observed = obs_freq, poisson = pois_freq, neg_bin = nb_freq), 2)

png("outputs/week10/sufia_goals_observed_vs_expected.png", width = 900, height = 600, res = 120)
barplot(rbind(obs_freq, pois_freq, nb_freq), beside = TRUE, names.arg = max_goals,
        col = c("grey30", "steelblue", "darkorange"),
        legend.text = c("Observed", "Poisson", "Negative binomial"),
        args.legend = list(x = "topright", bty = "n"),
        xlab = "Goals scored", ylab = "Number of matches",
        main = "Observed and expected goals per match")
dev.off()

pois_conceded <- glm(goals_conceded ~ home_away + opponent_rank, family = poisson, data = match_data)
sum(residuals(pois_conceded, type = "pearson")^2) / df.residual(pois_conceded)

# Overview
# Week 6 found no overdispersion for goals scored (Pearson / df 0.99).
# Raw variance (1.99) is above the mean (1.30), but home/away and rank explain it.
# Negative binomial theta is about 34: very large, so it is almost Poisson.
# LRT about 0.06, p about 0.40 (halved, as theta is tested on the boundary).
# AIC goes up by about 2, and the rate ratios and SEs barely change.
# Observed and expected counts of each score match about equally well.
# So keep the Poisson model.
# Goals conceded are underdispersed (Pearson / df 0.57): negative binomial doesn't apply.
