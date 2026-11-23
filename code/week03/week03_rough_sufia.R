# Week 03 — Introduction to GLMs
# Rough exploratory work: Sufia

source("code/setup.R")

# ---- Sufia: 5. data structure: players grouped within teams ----

nlevels(player_data$team)
nrow(player_data)

players_per_team <- table(player_data$team)
players_per_team
summary(as.numeric(players_per_team))

team_position <- table(player_data$team, player_data$position)
team_position
write.csv(as.data.frame.matrix(team_position),
          "outputs/week03/sufia_team_position_counts.csv")

team_summary <- data.frame(
  team         = levels(player_data$team),
  players      = as.numeric(tapply(player_data$injured, player_data$team, length)),
  injury_rate  = round(as.numeric(tapply(player_data$injured, player_data$team, mean)), 3),
  mean_minutes = round(as.numeric(tapply(player_data$minutes_played, player_data$team, mean)), 1)
)
team_summary <- team_summary[order(team_summary$injury_rate), ]
team_summary
write.csv(team_summary, "outputs/week03/sufia_team_summary.csv", row.names = FALSE)

par(mar = c(5, 9, 3, 1))
barplot(team_summary$injury_rate,
        names.arg = team_summary$team,
        horiz = TRUE, las = 1, cex.names = 0.7,
        xlim = c(0, 0.5),
        main = "Injury rate by team",
        xlab = "Proportion of players injured")
abline(v = mean(player_data$injured), lty = 2)
dev.copy(png, "outputs/week03/sufia_injury_rate_by_team.png", width = 900, height = 700, res = 120)
dev.off()

team_order <- reorder(player_data$team, player_data$minutes_played, FUN = median)
boxplot(player_data$minutes_played ~ team_order,
        horizontal = TRUE, las = 1, cex.axis = 0.7,
        main = "Minutes played by team",
        xlab = "Minutes played over the season", ylab = "")
abline(v = mean(player_data$minutes_played), lty = 2)
dev.copy(png, "outputs/week03/sufia_minutes_by_team.png", width = 900, height = 700, res = 120)
dev.off()
par(mar = c(5, 4, 4, 2) + 0.1)

summary(aov(minutes_played ~ team, data = player_data))

team_aov   <- anova(lm(minutes_played ~ team, data = player_data))
ms_between <- team_aov["team", "Mean Sq"]
ms_within  <- team_aov["Residuals", "Mean Sq"]
n_i <- as.numeric(players_per_team)
n0  <- (sum(n_i) - sum(n_i^2) / sum(n_i)) / (length(n_i) - 1)
icc_minutes <- (ms_between - ms_within) / (ms_between + (n0 - 1) * ms_within)
icc_minutes

team_injury_test <- chisq.test(table(player_data$team, player_data$injured))
team_injury_test
sum(team_injury_test$expected < 5)

nrow(match_data)
table(match_data$home_away)
table(match_data$opponent_rank)
setdiff(1:24, match_data$opponent_rank)
sum(player_data$team == "Ashford United")

# Summary
# 620 players are nested within 24 teams (24 to 28 each).
# Players in the same team may not be independent.
# Injury rates range from 8% to 44%.
# Mean minutes range from about 2040 to 2800.
# The team effect is weak: ANOVA p = 0.053, ICC about 0.02.
# Chi squared for injury: p = 0.31 (15 expected counts below 5).
# Treating players as independent is fine for weeks 4 to 6.
# Team should be allowed for later with a random intercept (week 11).
# Match data: 46 Ashford games, each opponent home and away; Ashford are 9th.
