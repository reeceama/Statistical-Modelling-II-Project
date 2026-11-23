# Week 09 — Contingency tables II
# Rough exploratory work: Sufia

source("code/setup.R")

# ---- Sufia: 5. match data: home/away x opponent strength band x result ----

match_data$result <- factor(
  ifelse(match_data$goals_scored > match_data$goals_conceded, "Win",
         ifelse(match_data$goals_scored == match_data$goals_conceded, "Draw", "Loss")),
  levels = c("Loss", "Draw", "Win")
)
match_data$strength <- cut(match_data$opponent_rank, breaks = c(0, 8, 16, 24),
                           labels = c("Top", "Middle", "Bottom"))
table(match_data$opponent_rank, match_data$strength)

three_way <- table(match_data$home_away, match_data$strength, match_data$result,
                   dnn = c("home_away", "strength", "result"))
ftable(three_way)
write.csv(as.data.frame(three_way), "outputs/week09/sufia_match_three_way_table.csv", row.names = FALSE)

margin.table(three_way, c(1, 3))
margin.table(three_way, c(2, 3))
margin.table(three_way, c(1, 2))
round(prop.table(margin.table(three_way, c(1, 3)), 1), 3)
round(prop.table(margin.table(three_way, c(2, 3)), 1), 3)

chisq.test(margin.table(three_way, c(1, 3)))
chisq.test(margin.table(three_way, c(2, 3)))

counts <- as.data.frame(three_way)

m_indep  <- glm(Freq ~ home_away + strength + result, family = poisson, data = counts)
m_hs     <- glm(Freq ~ home_away * strength + result, family = poisson, data = counts)
m_hs_hr  <- glm(Freq ~ home_away * strength + home_away * result, family = poisson, data = counts)
m_hs_sr  <- glm(Freq ~ home_away * strength + strength * result, family = poisson, data = counts)
m_all2   <- glm(Freq ~ (home_away + strength + result)^2, family = poisson, data = counts)
m_sat    <- glm(Freq ~ home_away * strength * result, family = poisson, data = counts)

fits <- data.frame(
  model    = c("H + S + R", "HS + R", "HS + HR", "HS + SR", "HS + HR + SR", "HSR (saturated)"),
  deviance = round(sapply(list(m_indep, m_hs, m_hs_hr, m_hs_sr, m_all2, m_sat), deviance), 2),
  df       = sapply(list(m_indep, m_hs, m_hs_hr, m_hs_sr, m_all2, m_sat), df.residual)
)
fits$p_value <- round(pchisq(fits$deviance, fits$df, lower.tail = FALSE), 3)
fits
write.csv(fits, "outputs/week09/sufia_loglinear_models.csv", row.names = FALSE)

anova(m_hs, m_hs_hr, test = "Chisq")
anova(m_hs_hr, m_all2, test = "Chisq")
anova(m_all2, m_sat, test = "Chisq")
min(fitted(m_hs_hr))

result_cols <- c("firebrick", "grey70", "forestgreen")
png("outputs/week09/sufia_results_by_venue_strength.png", width = 1100, height = 550, res = 120)
par(mfrow = c(1, 2))
barplot(t(prop.table(margin.table(three_way, c(1, 3)), 1)), beside = TRUE, col = result_cols,
        legend.text = TRUE, args.legend = list(x = "topleft", bty = "n", cex = 0.8),
        main = "Result by home/away", ylab = "Proportion of matches", ylim = c(0, 0.8))
barplot(t(prop.table(margin.table(three_way, c(2, 3)), 1)), beside = TRUE, col = result_cols,
        legend.text = TRUE, args.legend = list(x = "top", bty = "n", cex = 0.8),
        main = "Result by opponent strength", ylab = "Proportion of matches", ylim = c(0, 0.8))
dev.off()

# Overview
# Ashford won 22, drew 11 and lost 13 of 46 matches.
# Opponents grouped as Top (ranks 1 to 8), Middle (10 to 16), Bottom (17 to 24).
# Home/away x strength is fixed by the fixtures, so it stays in every model.
# Home/away affects the result: 65% wins at home vs 30% away (chi squared p = 0.034).
# Adding home/away x result to HS + R improves the fit (LRT p = 0.03).
# HS + HR fits well: deviance 9.45 on 8 df, p = 0.31.
# Adding strength x result doesn't significantly improve it (LRT p = 0.09).
# The 3 way interaction isn't needed (p = 0.83).
# Many cells have counts of 0 to 2, so with only 46 matches the tests have low power.


