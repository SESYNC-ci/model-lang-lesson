---
---

## Linear Mixed Models

The [lme4](){:.rlib} package expands the formula "mini-language" to allow descriptions of "random effects". In the context of this package, variables added to the right of the `~` in the usual way are "fixed effects"---they consume a well-defined number of degrees of freedom. Variables added within `(...|...)` are "random effects".

===

The "variable intercepts" and "random slopes" classes of model are the two most common extensions to a formula with one variable.

| Formula           | Description                                                     |
|-------------------|-----------------------------------------------------------------|
| `y ~ a`           | constant and one fixed effect                                   |
| `y ~ (1 | b) + a` | random intercept for each level in `b` and one fixed effect     |
| `y ~ (1 + a | b)` | random intercepts and "slopes" w.r.t. `a` for each level in `b` |

===

## Random intercept

The `lmer` and `glmer` functions fit linear and generalized linear models with the `lme4` formula syntax.


~~~r
library(lme4)
fit <- lmer(log(weight) ~ (1 | species_id) + hindfoot_length,
            data = animals)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

~~~r
summary(fit)
~~~
{:.input}
~~~
Linear mixed model fit by REML ['lmerMod']
Formula: log(weight) ~ (1 | species_id) + hindfoot_length
   Data: animals

REML criterion at convergence: -11966.7

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-11.7117  -0.4802   0.1040   0.6123   7.4102 

Random effects:
 Groups     Name        Variance Std.Dev.
 species_id (Intercept) 0.25479  0.5048  
 Residual               0.03943  0.1986  
Number of obs: 30738, groups:  species_id, 24

Fixed effects:
                 Estimate Std. Error t value
(Intercept)     2.2138725  0.1051703   21.05
hindfoot_length 0.0436769  0.0007761   56.28

Correlation of Fixed Effects:
            (Intr)
hndft_lngth -0.175
~~~
{:.output}

The familiar assessment of model residuals is absent from the summary due to the lack of a widely accepted measure of null and residual deviance. The notions of model saturation, degrees of freedom, and independence of observations have all crossed onto thin ice.
{:.notes}

===

## Lack of independence

Models with random effects should be understood as specifying multiple, overlapping probability statements about the observations.

$$
\begin{align}
log(weight_i) &\sim Normal(\mu_i, \sigma_0^2) \\
\mu_i &= \beta_0 + \beta_1[species\_id_i] + \beta_2 * hindfoot\_length_i \\
\beta_1[j] &\sim Normal(0, \sigma_1^2) \\
\end{align}
$$

In a `lm` or `glm` fit, each response is conditionally independent, given it's predictors and the model coefficients. Each observation corresponds to it's own probability statement. In a model with random effects, each response is no longer conditionally independent, given it's predictors and model coefficients.
{:.notes}

===

## Exercise 4

Adjust the formula `log(weight) ~ hindfoot_length` to fit a "random intercepts" model, grouping by a different categorical variable (i.e. not species_id) in the `animals` data frame.

===

## Random slopes

Adding a numeric variable after the constant within a grouping specified by `(...|...)` produces a "random slope" model. Here, separate coefficients for hindfoot_length are allowed for each species.


~~~r
fit <- lmer(log(weight) ~ (1 + hindfoot_length | species_id),
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

Allowing each animal to use a constant and hindfoot_length coefficient shared only by other members of its `species` is a lot like fitting separate regressions for each species. Actual utility arises when combining this random slope predictor with other predictors *not* grouped by species.
{:.notes}

===

## Generalized Mixed Models

The `glmer` function merely adds to `lmer` the option to specify an exponential family distribution for the response variable.
