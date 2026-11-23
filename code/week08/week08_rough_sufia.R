# Week 08 — Contingency tables I
# Rough exploratory work: Sufia

source("code/setup.R")

# ---- Sufia: 4. team x injured ----

team_injured <- table(player_data$team, player_data$injured)
colnames(team_injured) <- c("Not injured", "Injured")
team_injured

team_props <- round(prop.table(team_injured, 1), 3)
team_props[order(team_props[, "Injured"]), ]
write.csv(as.data.frame.matrix(team_props), "outputs/week08/sufia_team_injury_proportions.csv")

team_test <- chisq.test(team_injured)
team_test

round(team_test$expected, 2)
sum(team_test$expected < 5)
min(team_test$expected)

set.seed(6134)
chisq.test(team_injured, simulate.p.value = TRUE, B = 10000)

team_stdres <- round(team_test$stdres[, "Injured"], 2)
sort(team_stdres)
team_stdres[abs(team_stdres) > 2]
write.csv(data.frame(team = names(team_stdres), std_residual_injured = team_stdres),
          "outputs/week08/sufia_team_std_residuals.csv", row.names = FALSE)

sorted_res <- sort(team_stdres)
png("outputs/week08/sufia_team_std_residuals.png", width = 900, height = 900, res = 120)
par(mar = c(5, 9, 3, 1))
bar_pos <- barplot(sorted_res, horiz = TRUE, names.arg = NA,
                   xlim = c(-2.5, 4),
                   main = "Standardised residuals (injured) by team",
                   xlab = "Standardised residual")
mtext(names(sorted_res), side = 2, at = bar_pos, las = 1, line = 0.5, cex = 0.65)
abline(v = c(-2, 2), lty = 2)
dev.off()

# Overview
# Team x injured is a 24 x 2 table.
# Chi squared = 25.8 on 23 df, p = 0.31: no evidence injury rates differ by team.
# 15 of 48 expected counts are below 5 (smallest 4.5), so the test is only approximate.
# A simulated p value avoids this and gives the same answer (about 0.31).
# Only Grantwick FC stands out: 12 of 27 injured (44%), standardised residual 3.5.
# With 24 teams, one residual above 2 is about what chance would give.
# This matches week 3: the team effect on injury is small (checked again in week 11).
