---
---

## Generalized Linear Models

In linear models, like those fit with `lm`, the distribution of the response variable is assumed to be a normal or gaussian. However, in many cases this assumption is not appropriate. 
{:.notes}

*Generalized* linear models allow for other distributions for the response variable, such as binomial or exponential distributions. In generalized linear models, a *link* function is used to transform the response variable. This causes the response variable to follow a more linear relationship with the predictor variables. 

===

Generalized linear models can be fit in R using the `glm` function, which is a part of base R. The `formula` syntax in the `lm` and `glm` functions are the same, but an additional argument, `family`, is used in `glm` to specify the distribution. 

The `family` argument determines the family of probability distributions in
which the response variable belongs.

===

| Family             | Data Type | (*default*) link functions             |
|--------------------|-----------|----------------------------------------|
| `gaussian`         | `double`  | *identity*, log, inverse               |
| `binomial`         | `boolean` | *logit*, probit, cauchit, log, cloglog |
| `poisson`          | `integer` | *log*, identity, sqrt                  |
| `Gamma`            | `double`  | *inverse*, identity, log               |
| `inverse.gaussian` | `double`  | *"1/mu^2"*, inverse, identity, log     |



===

The previous model fit with `lm` is (almost) identical to a model fit using
`glm` with the Gaussian family and identity link.



~~~r
fit <- glm(log(WAGP) ~ SCHL,
    family = gaussian,
    data = pums)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> summary(fit)
~~~
{:title="Console" .input}


~~~

Call:
glm(formula = log(WAGP) ~ SCHL, family = gaussian, data = pums)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-8.3795  -0.4623   0.2330   0.8055   2.5084  

Coefficients:
                   Estimate Std. Error t value Pr(>|t|)    
(Intercept)         9.21967    0.05861 157.313  < 2e-16 ***
SCHLHigh School     0.54611    0.06816   8.012 1.45e-15 ***
SCHLCollege Credit  0.60397    0.06617   9.127  < 2e-16 ***
SCHLBachelor's      1.22164    0.07243  16.865  < 2e-16 ***
SCHLMaster's        1.36922    0.08615  15.894  < 2e-16 ***
SCHLDoctorate       1.49332    0.22155   6.740 1.79e-11 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for gaussian family taken to be 1.415141)

    Null deviance: 6633.8  on 4245  degrees of freedom
Residual deviance: 6000.2  on 4240  degrees of freedom
AIC: 13532

Number of Fisher Scoring iterations: 2
~~~
{:.output}


===

Question
: Should the coefficient estimates between this Gaussian `glm()` and the previous
`lm()` be different?

Answer
: {:.fragment} It's possible. The `lm()` function uses a different (less
general) fitting procedure than the `glm()` function, which uses IWLS. But with
64 bits used to store very precise numbers, it's rare to encounter an noticeable
difference in the optimum.

===

### Logistic Regression

Calling `glm` with `family = binomial` using the default "logit" link performs
logistic regression. We can use this to model the relationship between if an individual has insurance through their employer (`HINDS1`) and wages (`WAGP`).



~~~r
fit <- glm(HINS1 ~ WAGP,
  family = binomial,
  data = pums)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Interpreting the coefficients in the summary of the model is not obvious, but always works
the same way. Looking at the model, you can see that the slope for `WAGP` is significant. 



~~~r
summary(fit)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~

Call:
glm(formula = HINS1 ~ WAGP, family = binomial, data = pums)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-1.1614  -0.8791  -0.6448   1.2314   3.1749  

Coefficients:
              Estimate Std. Error z value Pr(>|z|)    
(Intercept) -3.765e-02  5.487e-02  -0.686    0.493    
WAGP        -2.855e-05  1.692e-06 -16.871   <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 5150.0  on 4245  degrees of freedom
Residual deviance: 4764.9  on 4244  degrees of freedom
AIC: 4768.9

Number of Fisher Scoring iterations: 5
~~~
{:.output}


===

To determine what this means, you have to look at the levels in the `HINS1` factor. 



~~~r
levels(pums$HINS1)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
[1] "1" "2"
~~~
{:.output}


In order, the levels are "1" and "2", which in the US Census data corresponds to yes and no, respectively for insurance through an employer. For a binomial distribution, the first level of the factor is considered 0 or "failure" and the other levels are considered 1 or "success." The predicted value, the linear combination of variables and coefficients, is the log odds of "success". So in this example, `HINS1` of 1 (has insurance through employer) is coded as a "0" in the model and `HINS1` level of 2 (does not have insurance through employer) is coded as a "1". 
{:.notes}

===

Because the slope of wages in the model is negative, this means that a lower wages corresponds to no insurance through employer. 

===

To make the analysis more intuitive, you can change the order of the levels in the factor so that the level "2" is coded as 0 and the level "1" is coded as 1 or success. 



~~~r
pums$HINS1 <- factor(pums$HINS1, levels = c("2", "1"))
levels(pums$HINS1)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
[1] "2" "1"
~~~
{:.output}


===

If you rerun the model, you can see that the estimates remain the same, but the slope of `WAGP` is not positive, not negative. 



~~~r
fit <- glm(HINS1 ~ WAGP,
  family = binomial,
  data = pums)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> summary(fit)
~~~
{:title="Console" .input}


~~~

Call:
glm(formula = HINS1 ~ WAGP, family = binomial, data = pums)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-3.1749  -1.2314   0.6448   0.8791   1.1614  

Coefficients:
             Estimate Std. Error z value Pr(>|z|)    
(Intercept) 3.765e-02  5.487e-02   0.686    0.493    
WAGP        2.855e-05  1.692e-06  16.871   <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 5150.0  on 4245  degrees of freedom
Residual deviance: 4764.9  on 4244  degrees of freedom
AIC: 4768.9

Number of Fisher Scoring iterations: 5
~~~
{:.output}


===

The always popular $$R^2$$ indicator for goodness-of-fit is absent from the
summary of a `glm` result, as is the default F-Test of the model's significance.

===

The developers of `glm`, detecting an increase in user sophistication, are
leaving more of the model assessment up to you. The "null deviance" and
"residual deviance" provide most of the information we need. To test the fit of a generalized linear model, it is best to compare the deviance of model to the "null model," which is the model without predictor variables. Therefore, the null model only fits the intercept. 
{:.notes}

Use a Chi-squared test to see if the deviance in your model is lower than the null model.



~~~r
anova(fit, update(fit, HINS1 ~ 1), test = 'Chisq')
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
Analysis of Deviance Table

Model 1: HINS1 ~ WAGP
Model 2: HINS1 ~ 1
  Resid. Df Resid. Dev Df Deviance  Pr(>Chi)    
1      4244     4764.9                          
2      4245     5150.0 -1   -385.1 < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
~~~
{:.output}

