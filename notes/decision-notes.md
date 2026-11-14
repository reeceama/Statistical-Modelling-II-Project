# Decision notes

Record each analytical decision: what we decided, when, why, and what alternatives we considered.

## Week 02 — Exploration and normal linear regression

**15 Oct — Variable types** (Sufia)
Decided: Treat `training_load` as ordered categorical and `injured` as a binary factor (No/Yes); `team`, `position` and `home_away` as factors.
Why: `training_load` is a 1–5 rating, not a true measurement; `injured` is a yes/no outcome.
Alternatives: Treat `training_load` as numeric — to revisit when modelling.

**7 Nov — Model selection for `minutes_played`** (Reece)
Decided: I kept training load and position in the final model, with GK as the reference position to remain consistent with other files.
Why: I started with all five player variables and used backward elimination, dropping the term with the highest p-value each round. Age (p = 0.815), BMI (p = 0.749) and previous injuries (p = 0.535) were removed. Adding all three back barely changes the fit (F(3, 612) = 0.18, p = 0.91), and the final model has a lower AIC (9707.8 vs 9713.2), so the simpler model is preferred.
Alternatives: The full model with all five variables, and Saema's model with four.

**7 Nov — `training_load` kept numeric** (Reece)
Decided: I kept training load as a number rather than as categories in the model for minutes played.
Why: As a number, it only needs one coefficient instead of four, which makes it easier to interpret. I checked this by fitting it as categories, and it didn't improve the fit (F(3, 612) = 0.40, p = 0.75), so each level of training load adds roughly the same number of minutes.
Alternatives: Treating it as categories, as in Sufia's 15 Oct note.

## Week 03 — Introduction to GLMs

**8 Nov — Normal GLM for `minutes_played`** (Reece)
Decided: I modelled minutes played with a normal (gaussian) GLM and identity link, which is the same as the week 2 linear model.
Why: Minutes played is continuous and roughly symmetric, with the mean (2540) and median (2544) almost equal. The GLM gives exactly the same estimates as the linear model, so the week 2 results still hold.
Alternatives: A Gamma GLM, but minutes played isn't right-skewed, and Poisson, but it isn't a count of events.

## Week 04 — Binomial regression

**12 Nov — GK as the reference position for everyone** (Reece)
Decided: I moved setting GK as the reference position into `setup.R`, so every model that uses `player_data` compares positions with goalkeepers.
Why: R's default reference is the first level alphabetically, which is DEF. Goalkeepers are the clearest comparison, and setting it once in `setup.R` means everyone's models use the same reference without each person having to remember it. Changing the reference only relabels the position coefficients, so fit, AIC and test results stay the same.
Alternatives: Keeping DEF as the default, or setting the reference separately in each file.

**13 Nov — `training_load` kept numeric in the injury model** (Reece)
Decided: I kept training load as a number, so each step up in training load has the same effect on the odds of injury.
Why: The proportion injured at each level isn't perfectly steady (15%, 11%, 16%, 26%, 26%), so I checked it by fitting training load as categories. This didn't improve the fit (LRT p = 0.24) and had a higher AIC (549.1 vs 547.3), so the simpler numeric version is preferred. It also gives one odds ratio instead of four, which is easier to interpret.
Alternatives: Treating training load as categories.

## Week 05 — Residuals and diagnostics

## Week 06 — Poisson regression

## Week 08 — Contingency tables I

## Week 09 — Contingency tables II

## Week 10 — Specialised models

## Week 11 — Generalised linear mixed models

## Week 12 — Choosing analyses and planning the report
