# Decision notes

Record each analytical decision: what we decided, when, why, and what alternatives we considered.

## Week 02 — Exploration and normal linear regression

| Who and when | Decided | Why | Alternatives |
|--------------|---------|-----|--------------|
| Sufia, 15 Oct | Treat `training_load` as ordered categorical and `injured` as a binary factor (No/Yes); `team`, `position` and `home_away` as factors. | `training_load` is a 1–5 rating, not a true measurement; `injured` is a yes/no outcome. | Treat `training_load` as numeric — to revisit when modelling. |
| Reece, 7 Nov | I kept training load and position in the final model, with GK as the reference position to remain consistent with other files. | I started with all five player variables and used backward elimination, dropping the term with the highest p-value each round. Age (p = 0.815), BMI (p = 0.749) and previous injuries (p = 0.535) were removed. Adding all three back barely changes the fit (F(3, 612) = 0.18, p = 0.91), and the final model has a lower AIC (9707.8 vs 9713.2), so the simpler model is preferred. | The full model with all five variables. |
| Reece, 7 Nov | I kept training load as a number rather than as categories in the model for minutes played. | As a number, it only needs one coefficient instead of four, which makes it easier to interpret. I checked this by fitting it as categories, and it didn't improve the fit (F(3, 612) = 0.40, p = 0.75), so each level of training load adds roughly the same number of minutes. | Treating it as categories. |

## Week 03 — Introduction to GLMs

| Who and when | Decided | Why | Alternatives |
|--------------|---------|-----|--------------|
| Reece, 8 Nov | I modelled minutes played with a normal (gaussian) GLM and identity link, which is the same as the week 2 linear model. | Minutes played is continuous and roughly symmetric, with the mean (2540) and median (2544) almost equal. The GLM gives exactly the same estimates as the linear model, so the week 2 results still hold. | A Gamma GLM, but minutes played isn't right-skewed, and Poisson, but it isn't a count of events. |

## Week 04 — Binomial regression

| Who and when | Decided | Why | Alternatives |
|--------------|---------|-----|--------------|
| Reece, 12 Nov | I moved setting GK as the reference position into `setup.R`, so every model that uses `player_data` compares positions with goalkeepers. | R's default reference is the first level alphabetically, which is DEF. Goalkeepers are the clearest comparison, and setting it once in `setup.R` means everyone's models use the same reference without each person having to remember it. Changing the reference only relabels the position coefficients, so fit, AIC and test results stay the same. | Keeping DEF as the default, or setting the reference separately in each file. |
| Reece, 13 Nov | I kept training load as a number, so each step up in training load has the same effect on the odds of injury. | The proportion injured at each level isn't perfectly steady (15%, 11%, 16%, 26%, 26%), so I checked it by fitting training load as categories. This didn't improve the fit (LRT p = 0.24) and had a higher AIC (549.1 vs 547.3), so the simpler numeric version is preferred. It also gives one odds ratio instead of four, which is easier to interpret. | Treating training load as categories. |

## Week 05 — Residuals and diagnostics

| Who and when | Decided | Why | Alternatives |
|--------------|---------|-----|--------------|
| Reece, 15 Nov | I kept every unusual match and player in the data. | None were data errors, as they're real results and players within the dataset. No player was seriously influential in either model, as the largest Cook's distances were only 0.028 and 0.025, far below 1. | Removing the 8-0 match, which halves the variance of goals scored. |

## Week 06 — Poisson regression

| Who and when | Decided | Why | Alternatives |
|--------------|---------|-----|--------------|

## Week 08 — Contingency tables I

| Who and when | Decided | Why | Alternatives |
|--------------|---------|-----|--------------|

## Week 09 — Contingency tables II

| Who and when | Decided | Why | Alternatives |
|--------------|---------|-----|--------------|

## Week 10 — Specialised models

| Who and when | Decided | Why | Alternatives |
|--------------|---------|-----|--------------|

## Week 11 — Generalised linear mixed models

| Who and when | Decided | Why | Alternatives |
|--------------|---------|-----|--------------|

## Week 12 — Choosing analyses and planning the report

| Who and when | Decided | Why | Alternatives |
|--------------|---------|-----|--------------|
