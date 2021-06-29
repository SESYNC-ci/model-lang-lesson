---
---

## Linear Models

The formula requires a response variable left of a `~` and any number of
predictors to its right.

| Formula           | Description |
|-------------------|-------------|
| `y ~ a`           | constant and one predictor |
| `y ~ a + b`       | constant and two predictors |
| `y ~ a + b + a:b` | constant and two predictors and their interaction |

===

The constant (i.e. intercept) can be explicitly removed, although this is rarely
needed in practice. Assume an intercept is fitted unless its absence is explicitly noted.

| Formula      | Description |
|--------------|-------------|
| `y ~ -1 + a` | one predictor with no constant |

===

More or higher-order interactions are included with a shorthand that is sort of
consistent with the expression's algebraic meaning.

| Formula                | Description |
|------------------------|-------------|
| `y ~ a*b`              | all combinations of two variables  |
| `y ~ (a + b)^2`        | equivalent to `y ~ a*b` |
| `y ~ (a + b + ... )^n` | all combinations of all predictors up to order `n` |

===

Data transformation functions are allowed within the formula expression.

| Formula      | Description |
|--------------|-------------|
| `y ~ log(a)` | log transformed variable |
| `y ~ sin(a)` | periodic function of a variable |
| `y ~ I(a*b)` | product of variables, protected by `I` from expansion |

===

The `WAGP` variable is always positive and includes some values that
are many orders of magnitude larger than the mean.



~~~r
fit <- lm(
  log(WAGP) ~ SCHL,
  pums)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> summary(fit)
~~~
{:title="Console" .input}


~~~

Call:
lm(formula = log(WAGP) ~ SCHL, data = pums)

Residuals:
    Min      1Q  Median      3Q     Max 
-8.4081 -0.4712  0.2427  0.8023  2.5084 

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

Residual standard error: 1.19 on 4240 degrees of freedom
Multiple R-squared:  0.09518,	Adjusted R-squared:  0.09412 
F-statistic: 89.21 on 5 and 4240 DF,  p-value: < 2.2e-16
~~~
{:.output}


===

## Metadata Matters

For the predictors in a linear model, there is a big difference between factors
and numbers.



~~~r
fit <- lm(
  log(WAGP) ~ AGEP,
  pums)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> summary(fit)
~~~
{:title="Console" .input}


~~~

Call:
lm(formula = log(WAGP) ~ AGEP, data = pums)

Residuals:
    Min      1Q  Median      3Q     Max 
-8.8094 -0.5513  0.2479  0.8093  2.1933 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) 8.842905   0.055483  159.38   <2e-16 ***
AGEP        0.025525   0.001226   20.81   <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 1.191 on 4244 degrees of freedom
Multiple R-squared:  0.09261,	Adjusted R-squared:  0.0924 
F-statistic: 433.2 on 1 and 4244 DF,  p-value: < 2.2e-16
~~~
{:.output}


The difference between 1 and 5 model degrees of freedom between the last two
summaries---with one fixed effect each---arises because `SCHL` is a a factor
while `AGEP` is numeric. In the first case you get multiple intercepts,
while in the second case you get a slope.
{:.notes}
