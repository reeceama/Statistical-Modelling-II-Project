# Statistical-Modelling-II-Project

MTH6134 Statistical Modelling II group project: Reece, Sabrina, Saema, Sufia, Summer.

## Layout

- `data/`: raw data (do not edit)
- `code/setup.R`: loads both datasets; every script starts with `source("code/setup.R")`
- `code/weekXX/roughwork_yourname.R`: your own rough work; messy is fine
- `code/weekXX/weekXX_final.R`: the shared final code for the week
- `outputs/weekXX/`: plots as `.png` and tables as `.csv`, with your name in the file name (e.g. `reece_age_hist.png`)
- `notes/who-did-what.md`: your contributions, updated every week
- `notes/decision-notes.md`: modelling choices (what, when, why, alternatives)
- `reports/`: group report and individual reports

## First-time setup

1. Install R, RStudio and git.
2. In RStudio: **File → New Project → Version Control → Git** and paste `https://github.com/reeceama/Statistical-Modelling-II-Project.git`
3. Always open the project with `Statistical-Modelling-II-Project.Rproj` so file paths work.

## Every time you work

1. **Pull** (blue arrow in the Git tab).
2. Experiment in your `roughwork_name.R`.
3. When something is good, pull, then add it to the **bottom** of `weekXX_final.R` under `# ---- Name (15 Oct): what it does ----`.
4. Update `notes/who-did-what.md` and, for any modelling choice, `notes/decision-notes.md`.
5. **Commit** with a message like `week04 odds ratio CIs`, **pull** again, then **push**.

## Rules

- Never delete code or outputs, even ones we don't end up using; rough work stays in your roughwork file.
- Keep your row in `notes/who-did-what.md` accurate and up to date every week.
- Use relative file paths only (load data with `source("code/setup.R")`), so the code runs on everyone's computer.
