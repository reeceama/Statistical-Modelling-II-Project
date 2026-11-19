# Week 08 — Contingency tables I
# Rough exploratory work: Summer
# Keep everything; move good work into week08_final.R.
# Save outputs to outputs/week08/ with your name in the file name.

source("code/setup.R")


# SECTION 1 - Explore the variables

# Research question:
# Are players with more previous injuries
# more likely to be injured this season?

# Check that the player dataset has loaded
head(player_data)
dim(player_data)

# Examine previous injuries
table(player_data$prev_injuries)

# Examine current injury status
# 0 = Not injured, 1 = Injured
table(player_data$injured)


# SECTION 2 - Create a contingency table

# Keep complete observations for both variables
week08_data <- player_data[
  complete.cases(
    player_data[, c("prev_injuries", "injured")]
  ),
  c("prev_injuries", "injured")
]

# Create the contingency table
injury_table <- table(
  Previous_Injuries = week08_data$prev_injuries,
  Injured = week08_data$injured
)

# Display the table of counts
print(injury_table)

# Calculate proportions within each
# previous injury category
injury_proportions <- prop.table(
  injury_table,
  margin = 1
)

# Display percentages
round(injury_proportions * 100, 2)


# SECTION 3 - Chi-squared test

# Test whether previous injuries and
# current injury status are associated

chi_result <- chisq.test(injury_table)

# Display test statistic and p-value
print(chi_result)

# Check the expected frequencies
chi_result$expected

# Count expected frequencies below 5
sum(chi_result$expected < 5)


# SECTION 4 - Test for a trend

# Test whether the proportion injured
# changes systematically as previous
# injury count increases

trend_result <- prop.trend.test(
  x = injury_table[, "1"],
  n = rowSums(injury_table),
  score = as.numeric(rownames(injury_table))
)

print(trend_result)


# SECTION 5 - Standardised residuals

# Examine which cells contribute to
# the association in the table

standardised_residuals <- chi_result$stdres

# Display standardised residuals
round(standardised_residuals, 2)

# Flag cells with absolute residual > 2
abs(standardised_residuals) > 2

# SECTION 6 - Check the chi-squared approximation

# One expected cell has a count below 5.
# Use a Monte Carlo p-value as an additional check.

set.seed(6134)

chi_simulated <- chisq.test(
  injury_table,
  simulate.p.value = TRUE,
  B = 10000
)

# Display the simulated test results
print(chi_simulated)


# SECTION 7 - Interpretation of Week 8 results

# The analysis investigated the relationship
# between previous injuries and injury status
# among 620 football players.

# Injury rates increased with previous injuries:
# 0 previous injuries: 10.85%
# 1 previous injury:   19.30%
# 2 previous injuries: 27.66%
# 3 previous injuries: 38.46%
# 4 previous injuries: 42.86%

# The Pearson chi-squared test gave:
# Chi-squared = 35.258
# Degrees of freedom = 4
# p-value = 4.111e-07

# There is strong evidence of an association
# between previous injuries and current injury.

# The trend test gave:
# Chi-squared = 35.086
# p-value = 3.154e-09

# The injury proportions increase across
# the previous-injury categories.

# One expected count was below 5,
# so an additional simulated test was requested.

# Standardised residuals indicated fewer
# injured players than expected in the
# zero-previous-injury category.

# Categories with 2, 3 and 4 previous injuries
# had more injured players than expected.

# These findings indicate an association,
# but do not establish a causal relationship.


# The simulated chi-squared test used
# 10,000 Monte Carlo replicates.

# The simulated p-value was approximately
# 0.0001, the minimum possible at this
# simulation resolution.

# This supports the conclusion that previous
# injuries and current injury status
# are statistically associated.

# The trend test and observed percentages
# indicate an increasing injury rate
# with previous injury count.

# Association does not establish causation.

# SECTION 8 - Save Week 8 results

# Create the Week 8 output folder
dir.create(
  "outputs/week08",
  recursive = TRUE,
  showWarnings = FALSE
)

# Create a table of injury counts and percentages
injury_summary <- data.frame(
  Previous_Injuries = rownames(injury_table),
  Not_Injured = as.integer(injury_table[, "0"]),
  Injured = as.integer(injury_table[, "1"]),
  Injury_Rate_Percent = round(
    injury_proportions[, "1"] * 100, 2
  )
)

# Display the summary
print(injury_summary)

# Save the summary table
write.csv(
  injury_summary,
  "outputs/week08/summer_injury_table.csv",
  row.names = FALSE
)


# Save the expected frequencies
expected_table <- as.data.frame(
  chi_result$expected
)

write.csv(
  expected_table,
  "outputs/week08/summer_expected_counts.csv",
  row.names = TRUE
)


# Save standardised residuals
residual_table <- as.data.frame(
  standardised_residuals
)

write.csv(
  residual_table,
  "outputs/week08/summer_standardised_residuals.csv",
  row.names = TRUE
)


# Save statistical test results
test_summary <- data.frame(
  Test = c(
    "Pearson chi-squared",
    "Trend test",
    "Simulated chi-squared"
  ),
  Statistic = c(
    as.numeric(chi_result$statistic),
    as.numeric(trend_result$statistic),
    as.numeric(chi_simulated$statistic)
  ),
  P_Value = c(
    chi_result$p.value,
    trend_result$p.value,
    chi_simulated$p.value
  )
)

print(test_summary)

write.csv(
  test_summary,
  "outputs/week08/summer_test_results.csv",
  row.names = FALSE
)
