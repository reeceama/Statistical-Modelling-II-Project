# Statistical-Modelling-II-Project

MTH6134 Statistical Modelling II group project: Reece, Sabrina, Saema, Sufia, Summer.

## Layout

- `data/`: raw data (do not edit)
- `code/setup.R`: loads both datasets; every script starts with `source("code/setup.R")`
- `code/weekXX/weekXX_rough_yourname.R`: your own rough work; messy is fine
- `code/weekXX/weekXX_final.R`: the shared final code for the week
- `outputs/weekXX/`: plots as `.png` and tables as `.csv`, with your name in the file name (e.g. `name_age_hist.png`)
- `notes/who-did-what.md`: your contributions, updated every week
- `notes/decision-notes.md`: modelling choices (what, when, why, alternatives)
- `reports/`: group report and individual reports

## First-time setup

1. Install R, RStudio and git.
2. In RStudio: **File → New Project → Version Control → Git** and paste `https://github.com/reeceama/Statistical-Modelling-II-Project.git`
3. Always open the project with `Statistical-Modelling-II-Project.Rproj` so file paths work.

## Every time you work

1. **Pull first.** Open the project, go to the **Git** tab (top-right panel) and click the blue **Pull** arrow. This gets everyone else's latest changes before you start.
2. **Work in your rough work file.** Open `code/weekXX/weekXX_rough_yourname.R` and try things out. It can be messy, and nothing in it gets deleted. Save any plots or tables you want to keep to `outputs/weekXX/` with your name in the file name.
3. **Add good work to the final file.** When something works, click **Pull** again, then copy the clean version to the **bottom** of `code/weekXX/weekXX_final.R` under a header with your name, the date and what it does:
   ```r
   # ---- Name (20 Oct): what it does ----
   ```
   Run it once in the final file to check it works there too.
4. **Update the notes.** Add what you did to your row in `notes/who-did-what.md`. If you made a modelling choice (e.g. dropping a variable or choosing a model), add an entry to `notes/decision-notes.md` saying what you decided, why, and what else you considered.
5. **Commit and push.** In the Git tab:
   - tick the files you changed and click **Commit**;
   - write a short message saying what you did (e.g. `week04 odds ratio CIs`) and click **Commit**;
   - click **Pull** once more in case someone pushed while you worked, then click the green **Push** arrow.

If RStudio reports a **merge conflict**, the file will show both versions between `<<<<<<<` and `>>>>>>>` markers. Don't delete anyone's code; ask in the group chat and fix it together.

## Rules

- Never delete code or outputs, even ones we don't end up using; rough work stays in your rough work file.
- Keep your row in `notes/who-did-what.md` accurate and up to date every week.
- Use relative file paths only (load data with `source("code/setup.R")`), so the code runs on everyone's computer.
