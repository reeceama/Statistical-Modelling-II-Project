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

## Week 04 — Binomial regression

## Week 05 — Residuals and diagnostics

## Week 06 — Poisson regression

## Week 08 — Contingency tables I

## Week 09 — Contingency tables II

## Week 10 — Specialised models

## Week 11 — Generalised linear mixed models

## Week 12 — Choosing analyses and planning the report
