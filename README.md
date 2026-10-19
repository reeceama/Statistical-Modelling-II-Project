# Statistical-Modelling-II-Project

MTH6134 Statistical Modelling II group project: Reece, Sabrina, Saema, Sufia, Summer.

## Layout

- `data/`: raw data (do not edit)
- `code/setup.R`: loads both datasets; every script starts with `source("code/setup.R")`
- `code/weekXX/`: `weekXX_final.R` (shared final code) and `roughwork_name.R` (each member's rough work)
- `outputs/weekXX/`: plots and results, with your name in the file name
- `notes/`: `decision-notes.md` and `who-did-what.md`
- `reports/`: group report and individual reports

## First-time setup

1. Install R, RStudio and git, and make a GitHub account.
2. In RStudio: **File → New Project → Version Control → Git**, paste this repo's URL, and save it **outside OneDrive**.
3. Always open the project with `Statistical-Modelling-II-Project.Rproj` so file paths work.

## Every time you work

1. **Pull** (blue arrow in the Git tab).
2. Experiment in your `roughwork_name.R`.
3. When something is good, pull, then add it to the **bottom** of `weekXX_final.R` under `# ---- Name (15 Oct): what it does ----`.
4. Update `notes/who-did-what.md` and, for any modelling choice, `notes/decision-notes.md`.
5. **Commit** with a message like `Sufia: week04 odds ratio CIs`, **pull** again, then **push**.

## Rules

- Never delete code; rough work stays in your roughwork file.
- Only edit your own roughwork file; only add new blocks to the shared final file.
- At the end of each week, one person restarts R and runs `weekXX_final.R` top to bottom to check it works.
