---
---

## Linear models

The formula requires a response variable left of a "~" and any number of predictors to its right.

| Formula                | Equivalent            | Description                                                                               |
| `y ~ a`                | `y ~ 1 + a`           | constant and one predictor                                                                |
| `y ~ -1 + a`           | `y ~ 0 + a`           | one predictor with no constant                                                            |
| `y ~ a + b`            | `y ~ 1 + a + b`       | constant and two predictors                                                               |
| `y ~ a:b`              |                       | constant and one predictor, the interaction of (at least) one factor and another variable |
| `y ~ a*b`              | `y ~ 1 + a + b + a:b` | constant and three predictors                                                             |
| `y ~ a*b - a`          | `y ~ 1 + b + a:b`     | constant and two predictors                                                               |
| `y ~ (a + b + ... )^n` |                       | constant and all combinations of predictors up to order `n`                               |

===

## Linear model

In addition, certain functions are allowed within the formula definition.


~~~r
animals <- read.csv('data/animals.csv', stringsAsFactors = FALSE, na.strings = '')
fit <- lm(
  log(weight) ~ hindfoot_length,
  data = animals)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

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

## Exercise 1

Regress hindfoot_length against weight and species_id. Does it appear that the Chihuahuan Desert's common kangaroo rat (DM) have *inordinately* large feet for their weight?

===

## Pay attention to factors

Data type matters in statistical modelling. For the predictors in a linear model, the most important distinction is discrete versus continuous.


~~~r
animals$species_id <- factor(animals$species_id)
fit <- lm(
  log(weight) ~ species_id,
  data = animals)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

~~~r
summary(fit)
~~~
{:.input}
~~~

Call:
lm(formula = log(weight) ~ species_id, data = animals)

Residuals:
     Min       1Q   Median       3Q      Max 
-2.28157 -0.10063  0.02803  0.12574  1.48272 

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

Residual standard error: 0.2086 on 32258 degrees of freedom
  (3266 observations deleted due to missingness)
Multiple R-squared:  0.9216,	Adjusted R-squared:  0.9215 
F-statistic: 1.58e+04 on 24 and 32258 DF,  p-value: < 2.2e-16
~~~
{:.output}

The difference between 1 and 24 degrees of freedom between the last two models---with one fixed effect each---arises from the discreteness of `species_id`.
