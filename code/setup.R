# Shared setup: run at the top of every script with source("code/setup.R")
# Open the project via Statistical-Modelling-II-Project.Rproj so paths work.

matches <- read.csv("data/ashford_matches.csv", stringsAsFactors = TRUE)
players <- read.csv("data/league_players.csv", stringsAsFactors = TRUE)

# Make sure every weekly outputs folder exists
for (wk in c("02", "03", "04", "05", "06", "08", "09", "10", "11", "12")) {
  dir.create(file.path("outputs", paste0("week", wk)), recursive = TRUE, showWarnings = FALSE)
}
