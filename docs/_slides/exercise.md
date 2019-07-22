---
---

## Exercises

### Exercise 1

Regress `WKHP` against `AGEP`, adding a second-order interaction to allow for
possible curvature in the relationship. Plot the predicted values over the data
to verify the coefficients indicate a downward quadratic relationship.

### Exercise 2

Controlling for a person's educational attainment, fit a linear model that
addresses the question of wage disparity between men and women in the U.S.
workforce. What other predictor from the `person` data frame would increases the
goodness-of-fit of the "control" model, before SEX is considered.

### Exercise 3

Set up a generalized mixed effects model on whether a person attained an advanced
degree (Master's or Doctorate). Include sex and age as fixed effects, and include
a random intercept according to occupation.

### Exercise 4

Write down the formula for a random intercepts model for earned wages with a
fixed effect of sex and a random effect of educational attainment.

===

## Solutions



~~~r
fit <- lm(
  WKHP ~ AGEP + I(AGEP^2),
  person)

ggplot(person,
  aes(x = AGEP, y = WKHP)) +
  geom_point(shape = 'o') +
  geom_line(aes(y = predict(fit)))
~~~
{:title="Solution 1" .text-document}
![ ]({% include asset.html path="images/exercise/unnamed-chunk-1-1.png" %})
{:.captioned}



~~~r
fit <- lm(WAGP ~ SCHL, person)
summary(fit)
~~~
{:title="Solution 2" .text-document}


~~~

Call:
lm(formula = WAGP ~ SCHL, data = person)

Residuals:
   Min     1Q Median     3Q    Max 
-61303 -18827  -5827  12325 145173 

Coefficients:
                   Estimate Std. Error t value Pr(>|t|)    
(Intercept)           19614       1363  14.391  < 2e-16 ***
SCHLHigh School        8062       1630   4.945 7.89e-07 ***
SCHLCollege Credit    10214       1518   6.727 1.96e-11 ***
SCHLBachelor's        29976       1684  17.795  < 2e-16 ***
SCHLMaster's          35197       2003  17.569  < 2e-16 ***
SCHLDoctorate         43889       5152   8.519  < 2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 27660 on 4240 degrees of freedom
Multiple R-squared:  0.1389,	Adjusted R-squared:  0.1379 
F-statistic: 136.8 on 5 and 4240 DF,  p-value: < 2.2e-16
~~~
{:.output}


The "baseline" model includes educational attainment, when compared to a model
with sex as a second predictor, there is a strong indication of signifigance.



~~~r
anova(fit, update(fit, WAGP ~ SCHL + SEX))
~~~
{:title="Solution 2" .text-document}


~~~
Analysis of Variance Table

Model 1: WAGP ~ SCHL
Model 2: WAGP ~ SCHL + SEX
  Res.Df        RSS Df  Sum of Sq      F    Pr(>F)    
1   4240 3.2450e+12                                   
2   4239 3.0469e+12  1 1.9806e+11 275.55 < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
~~~
{:.output}


Adding WKHP to the baseline increases the $$R^2$$ to `.32` from `.14` with just
`SCHL`. There is no way to include the possibility that hours worked also
dependends on sex, giving a direct and indirect path to the gender wage gap, in
a linear model.



~~~r
summary(update(fit, WAGP ~ SCHL + WKHP))
~~~
{:title="Solution 2" .text-document}


~~~

Call:
lm(formula = WAGP ~ SCHL + WKHP, data = person)

Residuals:
   Min     1Q Median     3Q    Max 
-82762 -14392  -3919   9306 142326 

Coefficients:
                    Estimate Std. Error t value Pr(>|t|)    
(Intercept)        -16510.68    1627.64 -10.144  < 2e-16 ***
SCHLHigh School      3230.58    1458.67   2.215   0.0268 *  
SCHLCollege Credit   7146.98    1354.98   5.275 1.40e-07 ***
SCHLBachelor's      23865.31    1511.03  15.794  < 2e-16 ***
SCHLMaster's        27993.27    1796.83  15.579  < 2e-16 ***
SCHLDoctorate       34789.96    4595.62   7.570 4.54e-14 ***
WKHP                 1050.93      31.56  33.304  < 2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 24630 on 4239 degrees of freedom
Multiple R-squared:  0.3175,	Adjusted R-squared:  0.3165 
F-statistic: 328.6 on 6 and 4239 DF,  p-value: < 2.2e-16
~~~
{:.output}




~~~r
df <- person
levels(df$SCHL) <- c(0, 0, 0, 0, 1, 1)
fit <- glmer(
  SCHL ~ (1 | OCCP) + AGEP,
  family = binomial,
  data = df)
anova(fit, update(fit, . ~ . + SEX), test = 'Chisq')
~~~
{:title="Solution 3" .text-document}


~~~
Data: df
Models:
fit: SCHL ~ (1 | OCCP) + AGEP
update(fit, . ~ . + SEX): SCHL ~ (1 | OCCP) + AGEP + SEX
                         Df    AIC    BIC  logLik deviance  Chisq Chi Df
fit                       3 1996.5 2015.6 -995.27   1990.5              
update(fit, . ~ . + SEX)  4 1997.6 2023.0 -994.79   1989.6 0.9572      1
                         Pr(>Chisq)
fit                                
update(fit, . ~ . + SEX)     0.3279
~~~
{:.output}




~~~r
WAGP ~ (1 | SCHL) + SEX
~~~
{:title="Solution 4" .text-document}


~~~
WAGP ~ (1 | SCHL) + SEX
~~~
{:.output}

