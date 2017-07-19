---
---

## Generalized linear models

The `lm` function treats the response variable as numeric---the `glm` function lifts this restriction and others. Not through the `formula` syntax, which is the same for calls to `lm`  and `glm`, but through addition of the `family` argument.

===

## GLM families

The `family` argument determines the family of probability distributions in which the response variable belongs. A key difference between families is the data type and range.

| Family | Support | *Default* link |
|--------|---------|------------------|
| `gaussian` | `numeric` | *identity*, log, inverse |
| `binomial` | 2-level `factor` | *logit*, probit, cauchit, log, cloglog |
| `poisson` | non-negative `integer` | *log*, identity, sqrt |
| `Gamma` | positive `numeric` | *inverse*, identity, log |
| `inverse.gaussian` | positive `numeric` | *"1/mu^2"*, inverse, identity, log |

===

## Exercise 2

The default value for `family` is `gaussian(link = 'identity')`. Replace `lm` with `glm` (changing nothing else), to again fit the formula `log(weight) ~ species_id`. Compare the `summary()` between `lm()` and `glm()`, and identify something that is the same and something that is different in the output.

===

## Link with care

Correct use of the `link` argument to the family requires in-depth knowledge about generallize linear models---not our objective here. A common mistake to avoid, however, is assuming that `glm` applies the transfromation given as `link` to the response variable.


~~~r
fit <- glm(weight ~ hindfoot_length,
    family = gaussian(link = `log`),
    data = animals)
~~~
{:.input}

===

## Logistic regression

Calling `glm` with `familly = binomial` using the default "logit" link performs logistic regression.


~~~r
animals$sex <- factor(animals$sex)
fit <- glm(sex ~ hindfoot_length,
           family = binomial,
           data = animals)
~~~
{:.text-document title="{{ site.handouts }}"}

~~~r
summary(fit)
~~~
{:.input}
~~~

Call:
glm(formula = sex ~ hindfoot_length, family = binomial, data = animals)

Deviance Residuals: 
   Min      1Q  Median      3Q     Max  
-1.366  -1.207   1.057   1.124   1.246  

Coefficients:
                 Estimate Std. Error z value Pr(>|z|)    
(Intercept)     -0.179215   0.036495  -4.911 9.08e-07 ***
hindfoot_length  0.009571   0.001186   8.068 7.17e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 43408  on 31369  degrees of freedom
Residual deviance: 43343  on 31368  degrees of freedom
  (4179 observations deleted due to missingness)
AIC: 43347

Number of Fisher Scoring iterations: 3
~~~
{:.output}

===

## Weight

Both the `lm` and `glm` function allow a vector of `weights` the same length as the response. Weights can be necessary for logistic regression, depending on the format of the data. The `binomial` family `glm` works with three different response variable formats.

1. `factor` with two levels, as shown in the table above
1. `matrix` of type `integer` with two columns for the count of "successes" and "failures".
1. `numeric` between 0 and 1, specifying the proprtion of "successes" out of `weights` trials.

===

## Exercise 3

You are standing in the Chihuahuan desert, when a pocket mouse (genus Perognathus) suddenly runs up your pant leg. It doesn't weigh your pocket down much, relative to your many similar pocket mouse experiences. Run a binomial family GLM on the two Perognathus species in the Portal data that may help you predict to which species it belongs. Hint: The second `level()` of a factor is the "success" in a binomial GLM.

[View solution](#solution-3)
{:.notes}
