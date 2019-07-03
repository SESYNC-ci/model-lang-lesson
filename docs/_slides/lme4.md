---
---

## Linear Mixed Models

The [lme4](){:.rlib} package expands the formula "mini-language" to allow
descriptions of "random effects".

- normal predictors are "fixed effects"
- `(...|...)` expressions describe "random effects"

In the context of this package, variables
added to the right of the `~` in the usual way are "fixed effects"---they
consume a well-defined number of degrees of freedom. Variables added within
`(...|...)` are "random effects".
{:.notes}

===

The "random intercepts" and "random slopes" models are the two most common
extensions to a formula with one variable.

| Formula               | Description                                                 |
|-----------------------|-------------------------------------------------------------|
| `y ~ a`               | constant and one fixed effect                               |
| `y ~ (1 | b) + a`     | random intercept for each level in `b` and one fixed effect |
| `y ~ a + (a | b)`     | random intercept and slope w.r.t. `a` for each level in `b` |

===

### Random Intercept

The `lmer` and `glmer` functions fit linear and generalized linear models with
the `lme4` formula syntax.



~~~r
library(lme4)
fit <- lmer(
  hindfoot_length ~ (1|species_id) + log(weight),
  data = animals)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===



~~~r
> summary(fit)
~~~
{:title="Console" .input}


~~~
Linear mixed model fit by REML ['lmerMod']
Formula: hindfoot_length ~ (1 | species_id) + log(weight)
   Data: animals

REML criterion at convergence: 107596.2

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-17.3183  -0.5004   0.0254   0.5731  21.4700 

Random effects:
 Groups     Name        Variance Std.Dev.
 species_id (Intercept) 47.378   6.883   
 Residual                1.927   1.388   
Number of obs: 30738, groups:  species_id, 24

Fixed effects:
            Estimate Std. Error t value
(Intercept) 16.77000    1.41231   11.87
log(weight)  2.13065    0.03799   56.09

Correlation of Fixed Effects:
            (Intr)
log(weight) -0.087
~~~
{:.output}


The familiar assessment of model residuals is absent from the summary due to the
lack of a widely accepted measure of null and residual deviance. The notions of
model saturation, degrees of freedom, and independence of observations have all
crossed onto thin ice.
{:.notes}

===

### Non-independence

Models with random effects should be understood as specifying multiple,
overlapping probability statements about the observations.

$$
\begin{align}
&hindfoot\_length_i \sim Normal(\mu_i, \sigma_0^2) \\
&\mu_i = \beta_0 + \beta_1[species\_id_i] + \beta_2 \log(weight_i) \\
&\beta_1[j] \sim Normal(0, \sigma_1^2) \\
&\end{align}
$$

In a `lm` or `glm` fit, each response is conditionally independent, given it's
predictors and the model coefficients. Each observation corresponds to it's own
probability statement. In a model with random effects, each response is no
longer conditionally independent, given it's predictors and model coefficients.
{:.notes}

===

### Random Slope

Adding a numeric variable on the left of a grouping specified with `(...|...)`
produces a "random slope" model. Here, separate coefficients for hindfoot_length
are allowed for each species.



~~~r
fit <- lmer(
  hindfoot_length ~ 
    log(weight) + (log(weight) | species_id),
  data = animals)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
Warning in checkConv(attr(opt, "derivs"), opt$par, ctrl = control
$checkConv, : Model failed to converge with max|grad| = 0.00342356 (tol =
0.002, component 1)
~~~
{:.output}


===



~~~r
> summary(fit)
~~~
{:title="Console" .input}


~~~
Linear mixed model fit by REML ['lmerMod']
Formula: hindfoot_length ~ log(weight) + (log(weight) | species_id)
   Data: animals

REML criterion at convergence: 107030.8

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-17.4953  -0.4753   0.0349   0.5259  21.6529 

Random effects:
 Groups     Name        Variance Std.Dev. Corr
 species_id (Intercept) 19.7281  4.4416       
            log(weight)  0.6735  0.8207   0.76
 Residual                1.8905  1.3750       
Number of obs: 30738, groups:  species_id, 24

Fixed effects:
            Estimate Std. Error t value
(Intercept)  17.7169     0.9369  18.910
log(weight)   1.6920     0.1840   9.194

Correlation of Fixed Effects:
            (Intr)
log(weight) 0.573 
convergence code: 0
Model failed to converge with max|grad| = 0.00342356 (tol = 0.002, component 1)
~~~
{:.output}


===



![]({% include asset.html path="images/rs_plot-1.png" %})

===

### Generalized Mixed Models

The `glmer` function merely adds to `lmer` the option to specify several
exponential family distributions for the response variable.
