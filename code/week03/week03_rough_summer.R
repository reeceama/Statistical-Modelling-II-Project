# Week 03 — Introduction to GLMs
# Rough exploratory work: Summer
# Keep everything; move good work into week03_final.R.
# Save outputs to outputs/week03/ with your name in the file name.

source("code/setup.R")

# SECTION 1 - Variable Map
# Summer's allocated Week 3 task

# Aim:
# Classify the variables in both datasets
# and identify possible response and
# explanatory variables for statistical models.

# Examine the variables in the player dataset
names(player_data)
str(player_data)

# Examine the variables in the match dataset
names(match_data)
str(match_data)


# Create a variable map for the player dataset

player_map <- data.frame(
  Variable = c(
    "team", "position", "age", "minutes_played",
    "training_load", "prev_injuries", "bmi", "injured"
  ),
  
  Type = c(
    "Nominal categorical",
    "Nominal categorical",
    "Quantitative (years)",
    "Quantitative (minutes)",
    "Ordinal categorical (1-5)",
    "Count",
    "Continuous",
    "Binary (0/1)"
  ),
  
  Possible_Role = c(
    "Explanatory / grouping",
    "Explanatory",
    "Explanatory",
    "Response",
    "Explanatory",
    "Explanatory",
    "Explanatory",
    "Response"
  )
)

print(player_map)


# Create a variable map for the match dataset

match_map <- data.frame(
  Variable = c(
    "home_away", "goals_scored",
    "goals_conceded", "opponent_rank"
  ),
  
  Type = c(
    "Nominal categorical",
    "Count",
    "Count",
    "Ordinal ranking"
  ),
  
  Possible_Role = c(
    "Explanatory",
    "Response",
    "Response",
    "Explanatory"
  )
)

print(match_map)


# Identify potential GLM response variables

# Continuous response: minutes played
summary(player_data$minutes_played)

# Binary response: injured
table(player_data$injured)

# Count response: goals scored
table(match_data$goals_scored)

# Count response: goals conceded
table(match_data$goals_conceded)


# Save variable maps as CSV files

dir.create(
  "outputs/week03",
  recursive = TRUE,
  showWarnings = FALSE
)

write.csv(
  player_map,
  "outputs/week03/summer_player_variable_map.csv",
  row.names = FALSE
)

write.csv(
  match_map,
  "outputs/week03/summer_match_variable_map.csv",
  row.names = FALSE
)


# SECTION 2 - Interpretation of variable types

# minutes_played is a quantitative response.
# A Gaussian GLM can be used as an initial approach,
# although its assumptions would need checking.

# injured is a binary response coded 0 or 1.
# A binomial GLM with a logit link is suitable
# for modelling the probability of injury.

# goals_scored and goals_conceded are count outcomes.
# Poisson GLMs are natural starting models because
# they describe non-negative integer counts.

# team and position are nominal categorical variables.
# training_load is ordinal because scores 1 to 5
# have a natural ordering.

# The choice of response and explanatory variables
# depends on the specific research question.

# These classifications help guide the selection
# of statistical models in later weeks.


# SECTION 3 - Additional modelling considerations

# A variable can be a response or explanatory
# variable depending on the research question.

# For example, prev_injuries is used as an
# explanatory variable when studying injury risk,
# but could be a count response in another model.

# Age and minutes_played are recorded numerically,
# while BMI is a continuous measurement.

# minutes_played is recorded in whole minutes,
# but it is not an event count like goals scored.

# Team may also be used to account for grouping
# because players belong to different clubs.

# These classifications provide a starting point.
# Model suitability must be checked using
# assumptions and diagnostic methods.


