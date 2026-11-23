# Who did what

Running record of each member's contributions, updated weekly.

## Week 02 — Exploration and normal linear regression

| Member  | Contribution |
|---------|--------------|
| Reece   | Set up the GitHub repo and added the data files. (15 Oct) Designed the workspace structure. (18 Oct) Used backward elimination to find which variables affect minutes played, interpreted the final model with 95% CIs, made a table comparing the full and final models, and checked whether training load works better as a number or as categories. (7 Nov) Plotted minutes played by training load. (8 Nov) |
| Sabrina | |
| Saema   | Exploratory analysis of player and match datasets using variable classification, summary statistics, tables, and graphs. Linear regression to investigate how age, training load, previous injuries, and playing position relate to minutes played. (15th Oct) | 
| Sufia   | Exploratory analysis of both datasets: variable classification, summary statistics, six plots, linear models for minutes played and goals scored (15 Oct)|
| Summer  | Explored injury rates across age groups, training load, previous injuries, playing position and team using summary statistics and bar charts. Also investigated the relationship between previous injuries and minutes played using linear regression, confidence intervals and diagnostic plots. Found no statistically significant linear association between previous injuries and minutes played (p = 0.975). (7 Nov)

## Week 03 — Introduction to GLMs
| Member  | Contribution |
|---------|--------------|
| Reece   | Refitted my week 2 model as a normal GLM and showed it gives the same results as the linear model, explained what the deviance and dispersion mean, and checked whether a normal distribution suits minutes played using a histogram. (8 Nov) |
| Sabrina | |
| Saema   | Grouped players by team and compared injury rates and minutes played using summary statistics, bar charts and boxplots. Considered why player outcomes may be clustered within teams.
| Sufia   | Section 5, data structure. Compared injury rates and minutes played across the 24 teams with a bar chart, boxplot and tables. Found the team effect is weak (ANOVA p = 0.053, ICC about 0.02, chi squared for injury p = 0.31), so treating players as independent is fine for now, with team to be revisited in week 11. |
| Summer  | Completed the variable classification task for both player and match datasets. Identified possible response and explanatory variables and classified them as continuous, binary, count, nominal or ordinal. Explained the suitability of Gaussian, binomial and Poisson GLMs for different response types and created two CSV tables containing the variable classifications. (8 Nov)

## Week 04 — Binomial regression

| Member  | Contribution |
|---------|--------------|
| Reece   | Interpreted Summer's final injury model using odds ratios with 95% CIs, and also gave the effects of age per 5 years and training load from 1 to 5 to make them easier to picture. Also checked whether training load works better as a number or as categories in the injury model. (13 Nov) |
| Sabrina | |
| Saema   | Modelled injury probabilities across different training load levels and playing positions, producing plots to visualise the results.
| Sufia   | |
| Summer  | Carried out logistic regression model selection using likelihood ratio tests and AIC. Compared the full model containing age, training load, previous injuries, BMI and position with simpler alternatives. Found that the model retaining age, training load and previous injuries had the lowest AIC (547.27). The likelihood ratio test supported removing BMI and position (p = 0.5505), while all three retained predictors remained statistically significant. Identified this as the provisional preferred model, subject to agreement with the group's full model. (10 Nov)

## Week 05 — Residuals and diagnostics

| Member  | Contribution |
|---------|--------------|
| Reece   | Investigated the unusual observations. Looked at Ashford's 8-0 result and assessed how much it affected the mean and variance of goals scored. Following this, I found the most influential players in the minutes played model and injury model using Cook's distance. (15 Nov) |
| Sabrina | |
| Saema   | Checked the diagnostics of the final linear regression model for minutes played, assessing model assumptions and fit. 
| Sufia   | |
| Summer  | Investigated leverage and Cook's distance for the group's Week 2 linear regression model and a provisional Week 4 logistic regression model. Identified 28 observations exceeding the Cook's distance screening threshold in the linear model and 51 in the logistic model. Compared the five most influential observations in each model and found no overlap. Generated diagnostic plots and CSV tables. Logistic regression results will be reviewed once the group's final Week 4 model is agreed. (17 Nov) |

## Week 06 — Poisson regression

| Member  | Contribution |
|---------|--------------|
| Reece   | |
| Sabrina | |
| Saema   | Poisson regression to investigate how Ashford United’s goals scored relate to match location (home or away) and opponent league ranking. Exploratory analysis of goal counts, interpretation of model coefficients, and checks for overdispersion and model fit.(29th Oct)
| Sufia   | |
| Summer  |Investigated goodness of fit and overdispersion for a Poisson regression model of goals scored. Calculated the residual deviance (49.78), deviance-to-degrees-of-freedom ratio (1.16) and Pearson dispersion ratio (0.99). Fitted a quasi-Poisson model and compared coefficient estimates and standard errors, finding little evidence of substantial overdispersion. Saved diagnostic and model comparison tables. Analysis is provisional pending agreement on the group's Week 6 model. (19 Nov) |

## Week 08 — Contingency tables I

| Member  | Contribution |
|---------|--------------|
| Reece   | |
| Sabrina | |
| Saema   | Created win, draw and loss categories and investigated whether match outcomes were associated with home/away status. 
| Sufia   | |
| Summer  | |

## Week 09 — Contingency tables II

| Member  | Contribution |
|---------|--------------|
| Reece   | |
| Sabrina | |
| Saema   | Calculated and interpreted conditional odds ratios for the relationship between playing position and injury at different training load levels.
| Sufia   | |
| Summer  | |

## Week 10 — Specialised models

| Member  | Contribution |
|---------|--------------|
| Reece   | |
| Sabrina | |
| Saema   | investigated whether the count outcomes showed an excess number of zeros.
| Sufia   | |
| Summer  | |

## Week 11 — Generalised linear mixed models

| Member  | Contribution |
|---------|--------------|
| Reece   | |
| Sabrina | |
| Saema   | Fitted a logistic mixed-effects model with a random team intercept to investigate variation in player injury risk between teams. Compared it with an ordinary logistic regression model.
| Sufia   | |
| Summer  | |

## Week 12 — Choosing analyses and planning the report

| Member  | Contribution |
|---------|--------------|
| Reece   | |
| Sabrina | |
| Saema   | Selected three analyses from the project and justified their inclusion in the final statistical modelling work.
| Sufia   | |
| Summer  | |
