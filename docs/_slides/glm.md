---
---

## Generalized linear models

The `lm` function treats the response variable as numeric---the `glm` function lifts this restriction and others. Not through the `formula` syntax, which is the same for calls to `lm`  and `glm`, but through addition of the `family` argument.

===

## GLM families

| family | support | **default** link |
| `gaussian` | all reals | **identity**, log, inverse |
| `binomial` | boolean | **logit**, probit, cauchit, log, cloglog |
| `poisson` | non-negative integers | **log**, identity, sqrt |
| `Gamma` | positive reals | **inverse**, identity, log |
| `inverse.gaussian` | positive reals| **"1/mu^2"**, inverse, identity, log |

===

## Exercise 2

The default value for `family` is `gaussian(link = 'identity')`. Replace `lm` with `glm` (changing nothing else), to again fit the formula `log(weight) ~ species_id`. Compare the `summary()`. How, if at all, are the parameters, the parameter errors, or the description of residuals different?

===

## Logistic regression

Calling `glm` with the `familly = binomial` (using the default link) performs logistic regression.


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
lm(formula = log(weight) ~ hindfoot_length, data = animals)

Residuals:
     Min       1Q   Median       3Q      Max 
-2.39077 -0.21749 -0.05046  0.15017  2.08463 

Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
(Intercept)     1.5604389  0.0072416   215.5   <2e-16 ***
hindfoot_length 0.0650048  0.0002357   275.8   <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.3943 on 30736 degrees of freedom
  (4811 observations deleted due to missingness)
Multiple R-squared:  0.7122,	Adjusted R-squared:  0.7122 
F-statistic: 7.607e+04 on 1 and 30736 DF,  p-value: < 2.2e-16
~~~
{:.output}

===

## Exercise 3

You are standing in the Chihuahuan desert, when a pocket mouse (genus Perognathus) suddenly runs up your pant leg. It doesn't weigh your pocket down much, relative to your many similar pocket mouse experiences. Run a binomial family GLM on the two Perognathus species in the Portal data that may help you predict to which species it belongs. Hint: The second `level()` of a factor is the "success" in a binomial GLM.

[View solution](#solution-3)
{:.notes}
