---
---

## Generalized Linear Models

The `lm` function treats the response variable as numeric---the `glm` function
lifts this restriction and others. Not through the `formula` syntax, which is
the same for calls to `lm`  and `glm`, but through addition of the `family`
argument.

===

### GLM Families

The `family` argument determines the family of probability distributions in
which the response variable belongs. A key difference between families is the
data type and range.

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
    data = person)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===



~~~r
> summary(fit)
~~~
{:title="Console" .input}


~~~

Call:
glm(formula = log(WAGP) ~ SCHL, family = gaussian, data = person)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-8.4081  -0.4712   0.2427   0.8023   2.5084  

Coefficients:
                   Estimate Std. Error t value Pr(>|t|)    
(Intercept)         9.21967    0.05862 157.284  < 2e-16 ***
SCHLHigh School     0.57470    0.07011   8.197 3.23e-16 ***
SCHLCollege Credit  0.58083    0.06530   8.895  < 2e-16 ***
SCHLBachelor's      1.22164    0.07245  16.862  < 2e-16 ***
SCHLMaster's        1.36922    0.08616  15.891  < 2e-16 ***
SCHLDoctorate       1.49332    0.22159   6.739 1.81e-11 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for gaussian family taken to be 1.415654)

    Null deviance: 6633.8  on 4245  degrees of freedom
Residual deviance: 6002.4  on 4240  degrees of freedom
AIC: 13533

Number of Fisher Scoring iterations: 2
~~~
{:.output}


===

Question
: Should the coeficient estimates between this Gaussian `glm()` and the previous
`lm()` be different?

Answer
: {:.fragment} It's possible. The `lm()` function uses a different (less
general) fitting procedure than the `glm()` function, which uses IWLS. But with
64 bits used to store very precise numbers, it's rare to encounter an noticeable
difference in the optimum.

===

### Logistic Regression

Calling `glm` with `family = binomial` using the default "logit" link performs
logistic regression.



~~~r
fit <- glm(SEX ~ WAGP,
  family = binomial,
  data = person)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Interpretting the coefficients in the summary is non-obvious, but always works
the same way. In the `person` table, where men are coded as `1`, the `levels`
function shows that `2`, or women, are the first level. When using the binomial
family, the first level of the factor is consider 0 or "failure", and all remaining
levels (typically just one) are considered 1 or "success". The predicted value, the linear combination of variables and coeficients, is the log odds of "success".
{:.notes}

The positive coefficient on `WAGP` implies that a higher wage tilts the
prediction towards men.



~~~r
> summary(fit)
~~~
{:title="Console" .input}


~~~

Call:
glm(formula = SEX ~ WAGP, family = binomial, data = person)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-2.1479  -1.1225   0.6515   1.1673   1.3764  

Coefficients:
              Estimate Std. Error z value Pr(>|z|)    
(Intercept) -4.567e-01  4.906e-02  -9.308   <2e-16 ***
WAGP         1.519e-05  1.166e-06  13.028   <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 5883.3  on 4245  degrees of freedom
Residual deviance: 5692.7  on 4244  degrees of freedom
AIC: 5696.7

Number of Fisher Scoring iterations: 4
~~~
{:.output}


===

The always popular $$R^2$$ indicator for goodness-of-fit is absent from the
summary of a `glm` result, as is the defult F-Test of the model's significance.

The developers of `glm`, detecting an increase in user sophistication, are
leaving more of the model assessment up to you. The "null deviance" and
"residual deviance" provide most of the information we need. The `?anova.glm`
function allows us to apply the F-test on the deviance change, although there is
a better alternative.
{:.notes}



~~~r
anova(fit, update(fit, SEX ~ 1), test = 'Chisq')
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
Analysis of Deviance Table

Model 1: SEX ~ WAGP
Model 2: SEX ~ 1
  Resid. Df Resid. Dev Df Deviance  Pr(>Chi)    
1      4244     5692.7                          
2      4245     5883.3 -1  -190.51 < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
~~~
{:.output}


===

### Observation Weights

Both the `lm()` and `glm()` function allow a vector of weights the same length
as the response. Weights can be necessary for logistic regression, depending on
the format of the data. The `binomial` family `glm()` works with three different
response variable formats.

1. `factor` with only, or coerced to, two levels (binary)
1. `matrix` with two columns for the count of "successes" and "failures"
1. `numeric` proprtion of "successes" out of `weights` trials

Depending on your model, these three formats are not necesarilly
interchangeable.
{:.notes}
