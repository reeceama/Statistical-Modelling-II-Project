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
3. **Add good work to the final file through a pull request.** See [Adding to a final file](#adding-to-a-final-file) below.
4. **Update the notes.** Add what you did to your row in `notes/who-did-what.md`. If you made a modelling choice (e.g. dropping a variable or choosing a model), add an entry to `notes/decision-notes.md` saying what you decided, why, and what else you considered.
5. **Commit and push.** In the Git tab:
   - tick the files you changed and click **Commit**;
   - write a short message saying what you did (e.g. `week04 odds ratio CIs`) and click **Commit**;
   - click **Pull** once more in case someone pushed while you worked, then click the green **Push** arrow.

If RStudio reports a **merge conflict**, the file will show both versions between `<<<<<<<` and `>>>>>>>` markers. Don't delete anyone's code; ask in the group chat and fix it together.

## Adding to a final file

Changes to `weekXX_final.R` and `code/setup.R` go through a pull request, so someone checks them before they reach `main`. Rough work and notes don't need one.

1. **Copy your clean code in.** Paste it into `code/weekXX/weekXX_final.R` in the order of your section number from the weekly plan, under a header with your name, the date you did the work, your section number and what it does:
   ```r
   # ---- Name (20 Oct): 2. what it does ----
   ```
2. **Check it runs with everyone else's code.** Click **Session → Restart R**, then **Source** to run the whole final file from the top.
3. **Open a pull request.**
   - **In RStudio:** click **Pull**, then the purple **New Branch** button in the Git tab, and name it e.g. `name-week04`. Commit and push as normal. On GitHub, click **Compare & pull request** on the yellow banner, write a line on what you added, and click **Create pull request**.
   - **On the GitHub website:** after editing or uploading the file, click **Commit changes**, choose **Create a new branch for this commit and start a pull request**, then click **Propose changes** and **Create pull request**.
4. **Someone else reviews it.** They look at the **Files changed** tab and either approve it or leave a comment. To fix something, commit to the same branch and the pull request updates.

   **If you're reviewing, don't edit someone else's code.** Instead:
   - leave a comment on the line in the **Files changed** tab saying what needs changing;
   - click **Request changes** so it's clear it isn't ready to merge;
   - for small fixes, click the **±** icon while commenting and type the corrected line; the author can then click **Commit suggestion** to accept it;
   - once the author has fixed it, check again and approve.
5. **Merge it.** Once approved, click **Merge pull request** and delete the branch. In RStudio, switch back to `main` using the branch menu in the Git tab, then click **Pull**.

## Rules

- Never delete code or outputs, even ones we don't end up using; rough work stays in your rough work file.
- Keep your row in `notes/who-did-what.md` accurate and up to date every week.
- Use relative file paths only (load data with `source("code/setup.R")`), so the code runs on everyone's computer.
