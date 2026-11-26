# Week 05 — Residuals and diagnostics
# Shared final code. Add good work from your rough work file at the bottom under:
# # ---- Name (15 Oct): what it does ----
# Save outputs to outputs/week05/

source("code/setup.R")


# ---- Reece (15 Nov): 4. unusual observations ----
# Uses Summer's models and Cook's distances from section 3 (linear_model, logistic_model, linear_cooks, logistic_cooks).

# ----- 4.1 The 8-0 match -----

# The number of matches with each number of goals scored by Ashford.
table(match_data$goals_scored)

# Finds the game where Ashford won 8-0 and displays its details.
# The 8-0 game, played at home, occurred against the bottom ranked team in the dataset (24).
big_win <- which(match_data$goals_scored == 8)
match_data[big_win, ]

# The mean and variance of goals scored per game (1.304, 1.994)
c(
  mean = mean(match_data$goals_scored),
  variance = var(match_data$goals_scored)
)

# The mean and variance of goals scored per game, excluding the big win (1.156, 0.998)
# The mean changes a small amount when removing the 8-0 result, while the variance falls by roughly half.
c(
  mean = mean(match_data$goals_scored[-big_win]),
  variance = var(match_data$goals_scored[-big_win])
)


# ----- 4.2 Unusual players in the minutes played model -----

# Standardised residuals: 25 players beyond ±2 and none beyond ±3.
minutes_resid <- rstandard(linear_model)
sum(abs(minutes_resid) > 2)
sum(abs(minutes_resid) > 3)

# The most influential player: an Ulverton FC goalkeeper who played 1705 minutes (predicted 3419).
player_data[which.max(linear_cooks), ]

# Row numbers of players with Cook's distance above 4/n, from largest to smallest.
top_minutes <- order(-linear_cooks)[1:sum(linear_cooks > 4 / nrow(player_data))]

# Table of those players, with the minutes the model predicted for them.
top_minutes_table <- data.frame(
  team = player_data$team[top_minutes],
  position = player_data$position[top_minutes],
  training_load = player_data$training_load[top_minutes],
  minutes_played = player_data$minutes_played[top_minutes],
  predicted = round(fitted(linear_model)[top_minutes]),
  residual = round(minutes_resid[top_minutes], 2),
  cooks = round(linear_cooks[top_minutes], 4)
)
top_minutes_table

# Saves the influential players in the minutes model.
write.csv(top_minutes_table, "outputs/week05/reece_mins_influential.csv")


# ----- 4.3 Unusual players in the injury model -----

# Row numbers of players with Cook's distance above 4/n, from largest to smallest.
top_injury <- order(-logistic_cooks)[1:sum(logistic_cooks > 4 / nrow(player_data))]

# Table of those players with their predicted chance of injury. None are seriously influential, as every Cook's distance is far below 1.
# 48 of the 51 were injured despite a low predicted chance and the other 3 weren't despite a high one, so these are players the model can't explain, not errors in the data.
top_injury_table <- data.frame(
  team = player_data$team[top_injury],
  age = player_data$age[top_injury],
  training_load = player_data$training_load[top_injury],
  prev_injuries = player_data$prev_injuries[top_injury],
  injured = player_data$injured[top_injury],
  predicted = round(fitted(logistic_model)[top_injury], 3),
  cooks = round(logistic_cooks[top_injury], 4)
)
top_injury_table

# Saves the influential players in the injury model.
write.csv(top_injury_table, "outputs/week05/reece_injury_influential.csv")


# ----- 4.4 Conclusion -----

# None of the unusual observations are data errors, so all are kept in the data.
# The 8-0 match is far above Ashford's usual score, and removing it halves the variance of goals scored (1.994 to 0.998).
# No player is seriously influential in either model, as the largest Cook's distances are only 0.028 and 0.025.
# The players that stand out are mostly backup goalkeepers and players at the 3960 minute cap in the minutes model, and unexpected injuries in the injury model.
