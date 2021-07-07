---
---

## Linear Regression

With the US Census data, we will use a linear regression to determine the relationship between educational attainment (`SCHL`) and wages (`WAGP`). The basic function for fitting a regression in R is the `lm()` function,
standing for linear model.



~~~r
fit.schl <- lm(
  formula = WAGP ~ SCHL,
  data = pums)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


The `lm()` function takes a formula argument and a data argument, and computes
the best fitting linear model (i.e. determines coefficients that [minimize the
sum of squared residuals].
{:.notes}

[minimize the sum of squared residuals]: https://en.wikipedia.org/wiki/Linear_least_squares_(mathematics)

===

Data visualizations can help confirm intuition, but only with very simple
models, typically with just one or two "fixed effects".



~~~r
> library(ggplot2)
> 
> ggplot(pums,
+   aes(x = SCHL, y = WAGP)) +
+   geom_boxplot()
~~~
{:title="Console" .input}
![ ]({% include asset.html path="images/lm/unnamed-chunk-2-1.png" %})
{:.captioned}

===

Within the formula expressions, data transformation functions can also be used. 

| Formula      | Description |
|--------------|-------------|
| `y ~ log(a)` | log transformed variable |
| `y ~ sin(a)` | periodic function of a variable |
| `y ~ I(a*b)` | product of variables, protected by `I` from expansion |

===

The `WAGP` variable is always positive and includes some values that
are many orders of magnitude larger than the mean. Therefore, we can log transform the wages in the model.



~~~r
fit.schl <- lm(
  log(WAGP) ~ SCHL,
  pums)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> summary(fit.schl)
~~~
{:title="Console" .input}


~~~

Call:
lm(formula = log(WAGP) ~ SCHL, data = pums)

Residuals:
    Min      1Q  Median      3Q     Max 
-8.3795 -0.4623  0.2330  0.8055  2.5084 

Coefficients:
                   Estimate Std. Error t value Pr(>|t|)    
(Intercept)         9.21967    0.05861 157.313  < 2e-16 ***
SCHLHigh School     0.54611    0.06816   8.012 1.45e-15 ***
SCHLCollege Credit  0.60397    0.06617   9.127  < 2e-16 ***
SCHLBachelor's      1.22164    0.07243  16.865  < 2e-16 ***
SCHLMaster's        1.36922    0.08615  15.894  < 2e-16 ***
SCHLDoctorate       1.49332    0.22155   6.740 1.79e-11 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 1.19 on 4240 degrees of freedom
Multiple R-squared:  0.09551,	Adjusted R-squared:  0.09444 
F-statistic: 89.55 on 5 and 4240 DF,  p-value: < 2.2e-16
~~~
{:.output}


===

## Predictor class

For the predictors in a linear model, there is a big difference between factors and numbers.

===

Compare the model above which fit the wages and level of education (a factor) with one that uses age (a numerical category)



~~~r
fit.agep <- lm(
  log(WAGP) ~ AGEP,
  pums)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> summary(fit.agep)
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


===

In the model with `AGEP`, the intercept and slope is fit. The slope describes the relationship between age and wages and can show a positive, negative, or no relationship between the two variables. 
{:.notes}

In the model with `SCHL`, multiple intercepts are fit. The same (Intercept) is fit and 5 intercepts for different factors of `SCHL`. 

As you can see, the `SCHL` level "Incomplete" is not fit. Each of the `SCHL` intercepts are based on the "Incomplete" factor, so "Incomplete"" is in theory the (Intercept) coefficient. 
For example, the intercept for "SCHLHigh School" is 0.57470, meaning that the log(wages) for someone who completed high school are 0.57 more than someone with incomplete school credit. 
{:.notes}
