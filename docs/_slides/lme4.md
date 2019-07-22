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

Models with random effects should be understood as specifying multiple,
overlapping probability statements about the observations.

$$
\begin{align}
&\log(WAGP_i) \sim Normal(\mu_i, \sigma_0^2) \\
&\mu_i = \beta_0 + \boldsymbol{\beta_1}[OCCP_i] + \beta_2 \log(SCHL_i) \\
&\boldsymbol{\beta_1} \sim Normal(0, \boldsymbol{\Sigma_1}) \\
&\end{align}
$$

===

The "random intercepts" and "random slopes" models are the two most common
extensions to a formula with one variable.

| Formula                  | Description |
|--------------------------|-------------|
| `y ~ (1 | b) + a`        | random intercept for each level in `b` |
| `y ~ a + (a | b)`        | random intercept and slope w.r.t. `a` for each level in `b` |

===

### Random Intercept

The `lmer` function fits linear models with the [lme4](){:.rlib} extensions to
the `lm` formula syntax.




~~~r
library(lme4)
fit <- lmer(
  log(WAGP) ~ (1|OCCP) + SCHL,
  data = person)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===



~~~r
> summary(fit)
~~~
{:title="Console" .input}


~~~
Linear mixed model fit by REML ['lmerMod']
Formula: log(WAGP) ~ (1 | OCCP) + SCHL
   Data: person

REML criterion at convergence: 12766.4

Scaled residuals: 
    Min      1Q  Median      3Q     Max 
-8.6724 -0.3421  0.2034  0.6046  2.8378 

Random effects:
 Groups   Name        Variance Std.Dev.
 OCCP     (Intercept) 0.3945   0.6281  
 Residual             1.0598   1.0295  
Number of obs: 4246, groups:  OCCP, 380

Fixed effects:
                   Estimate Std. Error t value
(Intercept)         9.62243    0.06646 144.777
SCHLHigh School     0.34069    0.06304   5.404
SCHLCollege Credit  0.29188    0.06005   4.861
SCHLBachelor's      0.65614    0.07082   9.265
SCHLMaster's        0.88218    0.08742  10.092
SCHLDoctorate       1.04715    0.20739   5.049

Correlation of Fixed Effects:
            (Intr) SCHLHS SCHLCC SCHLB' SCHLM'
SCHLHghSchl -0.676                            
SCHLCllgCrd -0.736  0.752                     
SCHLBchlr's -0.677  0.653  0.723              
SCHLMastr's -0.568  0.528  0.586  0.602       
SCHLDoctort -0.232  0.218  0.242  0.242  0.247
~~~
{:.output}


The familiar assessment of model residuals is absent from the summary due to the
lack of a widely accepted measure of null and residual deviance. The notions of
model saturation, degrees of freedom, and independence of observations have all
crossed onto thin ice.
{:.notes}

In a `lm` or `glm` fit, each response is conditionally independent, given it's
predictors and the model coefficients. Each observation corresponds to it's own
probability statement. In a model with random effects, each response is no
longer conditionally independent, given it's predictors and model coefficients.
{:.notes}

===

### Random Slope

Adding a numeric variable on the left of a grouping specified with `(...|...)`
produces a "random slope" model. Here, separate coefficients for hours worked
are allowed for each level of education.



~~~r
fit <- lmer(
  log(WAGP) ~ (WKHP | SCHL),
  data = person)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
Warning in checkConv(attr(opt, "derivs"), opt$par, ctrl = control
$checkConv, : Model failed to converge with max|grad| = 0.207748 (tol =
0.002, component 1)
~~~
{:.output}


===

The warning that the procedure `failed to converge` is worth paying attention
to. In this case, we can proceed by switching to the slower numerical optimizer
that [lme4](){:.rlib} previously used by default.



~~~r
fit <- lmer(
  log(WAGP) ~ (WKHP | SCHL),
  data = person, 
  control = lmerControl(optimizer = "bobyqa"))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> summary(fit)
~~~
{:title="Console" .input}


~~~
Linear mixed model fit by REML ['lmerMod']
Formula: log(WAGP) ~ (WKHP | SCHL)
   Data: person
Control: lmerControl(optimizer = "bobyqa")

REML criterion at convergence: 11670.1

Scaled residuals: 
    Min      1Q  Median      3Q     Max 
-9.4561 -0.3967  0.1710  0.6409  2.7948 

Random effects:
 Groups   Name        Variance  Std.Dev. Corr 
 SCHL     (Intercept) 11.986642 3.46217       
          WKHP         0.003189 0.05647  -1.00
 Residual              0.902750 0.95013       
Number of obs: 4246, groups:  SCHL, 6

Fixed effects:
            Estimate Std. Error t value
(Intercept)  11.3194     0.1052   107.6
~~~
{:.output}


===

The `predict` function extracts model predictions from a fitted model object
(i.e. the output of `lm`, `glm`, `lmer`, and `gmler`), providing one easy
way to visualize the effect of estimated coeficients.



~~~r
ggplot(person,
  aes(x = WKHP, y = log(WAGP), color = SCHL)) +
  geom_point() +
  geom_line(aes(y = predict(fit))) +
  labs(title = 'Random intercept and slope with lmer')
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/lme4/unnamed-chunk-5-1.png" %})
{:.captioned}

===

### Generalized Mixed Models

The `glmer` function adds upon `lmer` the option to specify the same group of
exponential family distributions for the residuals available to `glm`.
