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
workforce. What other predictor from the `pums` data frame would increase the
goodness-of-fit of the "control" model, before SEX is considered?

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
  pums)

ggplot(pums,
  aes(x = AGEP, y = WKHP)) +
  geom_point(shape = 'o') +
  geom_line(aes(y = predict(fit)))
~~~
{:title="Solution 1" .text-document}
![ ]({% include asset.html path="images/exercise/unnamed-chunk-1-1.png" %})
{:.captioned}



~~~r
fit <- lm(WAGP ~ SCHL, pums)
summary(fit)
~~~
{:title="Solution 2" .text-document}


~~~

Call:
lm(formula = WAGP ~ SCHL, data = pums)

Residuals:
   Min     1Q Median     3Q    Max 
-61303 -18649  -5649  12990 144351 

Coefficients:
                   Estimate Std. Error t value Pr(>|t|)    
(Intercept)           19614       1362  14.404  < 2e-16 ***
SCHLHigh School        7396       1584   4.670 3.11e-06 ***
SCHLCollege Credit    11035       1538   7.177 8.34e-13 ***
SCHLBachelor's        29976       1683  17.811  < 2e-16 ***
SCHLMaster's          35197       2002  17.585  < 2e-16 ***
SCHLDoctorate         43889       5148   8.526  < 2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 27640 on 4240 degrees of freedom
Multiple R-squared:  0.1405,	Adjusted R-squared:  0.1394 
F-statistic: 138.6 on 5 and 4240 DF,  p-value: < 2.2e-16
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
  Res.Df        RSS Df  Sum of Sq     F    Pr(>F)    
1   4240 3.2391e+12                                  
2   4239 3.0369e+12  1 2.0218e+11 282.2 < 2.2e-16 ***
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
lm(formula = WAGP ~ SCHL + WKHP, data = pums)

Residuals:
   Min     1Q Median     3Q    Max 
-82469 -14392  -3970   9369 141498 

Coefficients:
                   Estimate Std. Error t value Pr(>|t|)    
(Intercept)        -16544.1     1624.9 -10.181  < 2e-16 ***
SCHLHigh School      2874.5     1415.8   2.030   0.0424 *  
SCHLCollege Credit   7969.6     1371.2   5.812 6.63e-09 ***
SCHLBachelor's      23859.7     1508.8  15.814  < 2e-16 ***
SCHLMaster's        27986.6     1794.2  15.599  < 2e-16 ***
SCHLDoctorate       34781.5     4588.8   7.580 4.23e-14 ***
WKHP                 1051.9       31.5  33.398  < 2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 24600 on 4239 degrees of freedom
Multiple R-squared:  0.3195,	Adjusted R-squared:  0.3185 
F-statistic: 331.7 on 6 and 4239 DF,  p-value: < 2.2e-16
~~~
{:.output}




~~~r
df <- pums
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
                         npar    AIC    BIC  logLik deviance  Chisq Df
fit                         3 1996.5 2015.6 -995.27   1990.5          
update(fit, . ~ . + SEX)    4 1997.6 2023.0 -994.79   1989.6 0.9572  1
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

