---
---

## Generalized linear models

The `lm` function treats the response variable as numeric---the `glm` function lifts this restriction and others. Not through the `formula` syntax, which is the same for calls to `lm`  and `glm`, but through addition of the `family` argument.

===

## GLM families

The `family` argument determines the family of probability distributions in which the response variable belongs. A key difference between families is the data type and range.

===

| Family             | Data Type | *Default* link                         |
|--------------------|-----------|----------------------------------------|
| `gaussian`         | `double`  | *identity*, log, inverse               |
| `binomial`         | `boolean` | *logit*, probit, cauchit, log, cloglog |
| `poisson`          | `integer` | *log*, identity, sqrt                  |
| `Gamma`            | `double`  | *inverse*, identity, log               |
| `inverse.gaussian` | `double`  | *"1/mu^2"*, inverse, identity, log     |

===

The model fit in exercise 1 is (almost) identically produced with a GLM
using the Gaussian family and identity link.


~~~r
fit <- glm(log(weight) ~ species_id,
    family = gaussian,
    data = animals)
~~~
{:.text-document title="{{ site.handouts[0] }}"}


===


~~~r
summary(fit)
~~~
{:.input}

~~~

Call:
glm(formula = log(weight) ~ species_id, family = gaussian, data = animals)

Deviance Residuals: 
     Min        1Q    Median        3Q       Max  
-2.28157  -0.10063   0.02803   0.12574   1.48272  

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept)   2.12857    0.03110  68.448  < 2e-16 ***
species_idDM  1.62159    0.03117  52.031  < 2e-16 ***
species_idDO  1.74519    0.03134  55.690  < 2e-16 ***
species_idDS  2.63791    0.03139  84.024  < 2e-16 ***
species_idNL  2.89645    0.03170  91.373  < 2e-16 ***
species_idOL  1.29724    0.03181  40.780  < 2e-16 ***
species_idOT  1.04031    0.03142  33.110  < 2e-16 ***
species_idOX  0.91176    0.09066  10.056  < 2e-16 ***
species_idPB  1.30426    0.03135  41.609  < 2e-16 ***
species_idPE  0.92374    0.03165  29.188  < 2e-16 ***
species_idPF -0.07717    0.03155  -2.446 0.014447 *  
species_idPH  1.28769    0.04869  26.446  < 2e-16 ***
species_idPI  0.82629    0.08004  10.323  < 2e-16 ***
species_idPL  0.79433    0.04665  17.029  < 2e-16 ***
species_idPM  0.90396    0.03189  28.349  < 2e-16 ***
species_idPP  0.69278    0.03133  22.114  < 2e-16 ***
species_idPX  0.81448    0.15075   5.403 6.61e-08 ***
species_idRF  0.45257    0.03934  11.505  < 2e-16 ***
species_idRM  0.20908    0.03137   6.665 2.70e-11 ***
species_idRO  0.18447    0.08004   2.305 0.021191 *  
species_idRX  0.56824    0.15075   3.769 0.000164 ***
species_idSF  1.87613    0.04504  41.656  < 2e-16 ***
species_idSH  2.10024    0.03572  58.803  < 2e-16 ***
species_idSO  1.80152    0.04504  40.000  < 2e-16 ***
species_idSS  2.32672    0.15075  15.434  < 2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for gaussian family taken to be 0.04351748)

    Null deviance: 17905.2  on 32282  degrees of freedom
Residual deviance:  1403.8  on 32258  degrees of freedom
  (3266 observations deleted due to missingness)
AIC: -9551.9

Number of Fisher Scoring iterations: 2
~~~
{:.output}


===

Question
: Shouldn't the coeficient estimates between this `glm()` and the previous
`lm()` be different?

Answer
: {:.fragment} True, the `lm()` function uses a different (less general) fitting procedure than the `glm()` function, which uses IWLS. But on 64-bit machines,
it's rare to encounter an actual difference.

===

## Exercise 2

Weight is actually a positive integer in this dataset. Fit the log of weight
against species ID using `lm()`, and fit raw weight against species ID using
`glm()` with the Poisson family. According the the `anova()` table, are both
models plausible? Hint: you may need to provide additional arguments to
`anova()`.

[View solution](#solution-2)
{:.notes}

<!--
===

## Learn to link

Correct use of the `link` argument to the family requires in-depth knowledge
about generalized linear models---not our objective here. A common mistake to
avoid, however, is assuming that `glm` applies the transfromation given as
`link` to the response variable.


~~~r
## THIS IS PROBABLY NOT WHAT YOU WANT!
fit <- glm(weight ~ hindfoot_length,
    family = gaussian(link = `log`),
    data = animals)
~~~
{:.input}

-->

===

## Logistic regression

Calling `glm` with `familly = binomial` using the default "logit" link performs
logistic regression.


~~~r
animals$sex <- factor(animals$sex)
fit <- glm(sex ~ log(hindfoot_length),
           family = binomial,
           data = animals)
~~~
{:.text-document title="{{ site.handouts[0] }}"}


===


~~~r
summary(fit)
~~~
{:.input}

~~~

Call:
glm(formula = sex ~ log(hindfoot_length), family = binomial, 
    data = animals)

Deviance Residuals: 
   Min      1Q  Median      3Q     Max  
-1.313  -1.214   1.075   1.120   1.423  

Coefficients:
                     Estimate Std. Error z value Pr(>|z|)    
(Intercept)          -0.73611    0.11123  -6.618 3.64e-11 ***
log(hindfoot_length)  0.25205    0.03333   7.563 3.93e-14 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 43408  on 31369  degrees of freedom
Residual deviance: 43351  on 31368  degrees of freedom
  (4179 observations deleted due to missingness)
AIC: 43355

Number of Fisher Scoring iterations: 3
~~~
{:.output}


===

## Observation weights

Both the `lm()` and `glm()` function allow a vector of weights the same length
as the response. Weights can be necessary for logistic regression, depending on
the format of the data. The `binomial` family `glm()` works with three different
response variable formats.

1. `factor` **with two levels (binary)**
1. `matrix` of type `integer` with two columns for the count of "successes" and "failures".
1. `numeric` between 0 and 1, specifying the proprtion of "successes" out of `weights` trials.

Depending on your predictors, these three formats are not interchangeable.
{:.notes}

===

## Exercise 3

You are standing in the Chihuahuan desert, when a pocket mouse (genus
*Perognathus*) suddenly runs up your pant leg. It weighs down your pocket quite
a bit, relative to your many similar pocket mouse experiences. Run a binomial
family GLM on the two Perognathus species in the animals table that may help you
predict to which species it belongs. Hint: Begin by mutating `species_id` into a
`factor()` with `levels = c("PF", "PH")`.

[View solution](#solution-3)
{:.notes}
