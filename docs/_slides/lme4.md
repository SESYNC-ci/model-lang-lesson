---
---

## Linear Mixed Models

The [lme4](){:.rlib} package expands the formula "mini-language" to allow
descriptions of "random effects" into the linear model. These are called mixed models because they contain both fixed and random effects. 

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

For example, we can to fit the response variable log(WAGP) with the predictors of marital status (`MAR`) and education (`SCHL`), where `MAR` is a random effect and `SCHL` is a fixed effect. As assumed by linear models, the response variable, log(WAGP), is normally distributed, with a mean of \mu_i and standard deviation of \sigma_0^2. In addition, the random effect, `MAR` varies and has a normal distribution, with mean of 0 and standard deviation of \Sigma_1. The fixed effect, `SCHL` does not vary, and thus is a *fixed*.
{:.notes}

$$
\begin{align}
&\log(WAGP_i) \sim Normal(\mu_i, \sigma_0^2) \\
&\mu_i = \beta_0 + \boldsymbol{\beta_1}[MAR] + \beta_2 [SCHL_i] \\
&\boldsymbol{\beta_1} \sim Normal(0, \boldsymbol{\Sigma_1}) \\
&\end{align}
$$


===

Mixed models can be fit with "random intercepts" and "random slopes". With a random intercept, each level within the random effect can have a different intercept. With a random slope, each level can have a different slope. 

In `lme4` random effects are shown in the formula inside parentheses, with variables to the right of a "\|" to fit random intercept, and to the left to fit a random slope. 

===

| Formula                  | Description of random effect |
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
  log(WAGP) ~ (1|MAR) + SCHL,
  data = pums)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> summary(fit)
~~~
{:title="Console" .input}


~~~
Linear mixed model fit by REML ['lmerMod']
Formula: log(WAGP) ~ (1 | MAR) + SCHL
   Data: pums

REML criterion at convergence: 12995.7

Scaled residuals: 
    Min      1Q  Median      3Q     Max 
-7.7980 -0.3802  0.1780  0.6465  2.7135 

Random effects:
 Groups   Name        Variance Std.Dev.
 MAR      (Intercept) 0.1491   0.3862  
 Residual             1.2398   1.1134  
Number of obs: 4246, groups:  MAR, 5

Fixed effects:
                   Estimate Std. Error t value
(Intercept)         9.28460    0.18264  50.835
SCHLHigh School     0.40600    0.06410   6.334
SCHLCollege Credit  0.49035    0.06222   7.881
SCHLBachelor's      0.99794    0.06864  14.539
SCHLMaster's        1.10705    0.08150  13.584
SCHLDoctorate       1.26125    0.20772   6.072

Correlation of Fixed Effects:
            (Intr) SCHLHS SCHLCC SCHLB' SCHLM'
SCHLHghSchl -0.254                            
SCHLCllgCrd -0.259  0.763                     
SCHLBchlr's -0.232  0.699  0.719              
SCHLMastr's -0.197  0.590  0.607  0.560       
SCHLDoctort -0.077  0.231  0.238  0.220  0.186
~~~
{:.output}


===

In a `lm` or `glm` fit, each response is conditionally independent, given it's
predictors and the model coefficients. Each observation corresponds to it's own
probability statement. Mixed models allow you to specify random effects,  assuming that the response variable is *not* independent given the predictors and model coefficients. In short, mixed models account for the variation due to the random effects and then estimate the coefficients for the fixed effects. 
{:.notes}

Mixed models are more complicated to interpret. The familiar assessment of model residuals is absent from the summary due to the
lack of a widely accepted measure of null and residual deviance. One way to evaluate mixed models is to compare models with different combinations of fixed effects and to the null model. 
{:.notes}

We can create a null model where we include the random effect of marital status but take out the fixed effect of education. 



~~~r
null.model <- lmer(
  log(WAGP) ~ (1|MAR),
  data = pums)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

To compare the fit model to the null model, use the `anova` function. 



~~~r
anova(null.model, fit)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
refitting model(s) with ML (instead of REML)
~~~
{:.output}


~~~
Data: pums
Models:
null.model: log(WAGP) ~ (1 | MAR)
fit: log(WAGP) ~ (1 | MAR) + SCHL
           npar   AIC   BIC  logLik deviance  Chisq Df Pr(>Chisq)    
null.model    3 13310 13329 -6651.8    13304                         
fit           8 12992 13043 -6488.1    12976 327.37  5  < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
~~~
{:.output}


===

Based on a Chi-squared test, the fit model with education has a lower deviance than the null model, suggesting that education has an effect on wages. 

Other factors, such as AIC, BIC, and log likelihood scores are also often used to compare and evaluate mixed models. 
{:.notes}

===

### Random Slope

Adding a numeric variable on the left of a grouping specified with `(...|...)`
produces a "random slope" model. Here, separate coefficients for hours worked
are allowed for each level of education.



~~~r
fit <- lmer(
  log(WAGP) ~ (WKHP | SCHL),
  data = pums)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
Warning in checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv, :
unable to evaluate scaled gradient
~~~
{:.output}


~~~
Warning in checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv, :
Model failed to converge: degenerate Hessian with 1 negative eigenvalues
~~~
{:.output}


===

The warning that the procedure `failed to converge` is worth paying attention
to. One way to fix this is to change the numerical optimizer used for model fitting
that [lme4](){:.rlib} is used by default. In this example, we change the optimizer to a "BOBYQA" optimizer, which is slower than the default. 
{:.notes}



~~~r
fit <- lmer(
  log(WAGP) ~ (WKHP | SCHL),
  data = pums, 
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
   Data: pums
Control: lmerControl(optimizer = "bobyqa")

REML criterion at convergence: 11658.5

Scaled residuals: 
    Min      1Q  Median      3Q     Max 
-9.4553 -0.4071  0.1718  0.6258  2.7864 

Random effects:
 Groups   Name        Variance  Std.Dev. Corr 
 SCHL     (Intercept) 11.856218 3.44329       
          WKHP         0.003239 0.05692  -1.00
 Residual              0.900166 0.94877       
Number of obs: 4246, groups:  SCHL, 6

Fixed effects:
            Estimate Std. Error t value
(Intercept)  11.2851     0.1084   104.1
~~~
{:.output}


===

The `predict` function extracts model predictions from a fitted model object
(i.e. the output of `lm`, `glm`, `lmer`, and `glmer`), providing one easy
way to visualize the effect of estimated coefficients. We can plot the extracted coefficients using `ggplot`.



~~~r
ggplot(pums,
  aes(x = WKHP, y = log(WAGP), color = SCHL)) +
  geom_point() +
  geom_line(aes(y = predict(fit))) +
  labs(title = 'Random intercept and slope with lmer')
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/lme4/unnamed-chunk-7-1.png" %})
{:.captioned}

As you can see, each level of education has its own intercept **and** slope for the best fit line. 
{:.notes}

===

### Generalized Mixed Models

The `glmer` function adds upon `lmer` the option to specify the same group of
exponential family distributions as `glm` adds to `lm`. The same `family` argument is used in `glmer` to specify the distribution. 
