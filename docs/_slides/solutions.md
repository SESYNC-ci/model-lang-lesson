---
---

## Solutions

===

## Solution 1


~~~r
fit <- lm(
  hindfoot_length ~ species_id + log(weight),
  data = animals)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

The estimated coefficient for "species_idDM" and associated "***" suggest
"yes".


~~~r
summary(fit)
~~~
{:.input}
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
 species_id (Intercept) 19.7197  4.4407       
            log(weight)  0.6731  0.8205   0.76
 Residual                1.8905  1.3750       
Number of obs: 30738, groups:  species_id, 24

Fixed effects:
            Estimate Std. Error t value
(Intercept)  17.7170     0.9367  18.914
log(weight)   1.6920     0.1840   9.196

Correlation of Fixed Effects:
            (Intr)
log(weight) 0.573 
~~~
{:.output}

[Return](#exercise-1)
{:.notes}

===

## Solution 2


~~~r
fit_lm <- lm(log(weight) ~ species_id,
             data = animals)
fit_glm <- glm(weight ~ species_id,
               family = poisson,
               data = animals)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===


~~~r
anova(fit_lm)
~~~
{:.input}
~~~
Analysis of Variance Table

Response: log(weight)
              Df  Sum Sq Mean Sq F value    Pr(>F)    
species_id    24 16501.4  687.56   15800 < 2.2e-16 ***
Residuals  32258  1403.8    0.04                      
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
~~~
{:.output}

===


~~~r
anova(fit_glm, test = 'Chisq')
~~~
{:.input}
~~~
Analysis of Deviance Table

Model: poisson, link: log

Response: weight

Terms added sequentially (first to last)

           Df Deviance Resid. Df Resid. Dev  Pr(>Chi)    
NULL                       32282     775950              
species_id 24   718546     32258      57404 < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
~~~
{:.output}

[Return](#exercise-2)
{:.notes}

===

## Solution 3


~~~r
perognathus <- animals
perognathus$species_id <- factor(
  perognathus$species_id, levels = c('PF', 'PH'))
fit <- glm(species_id ~ weight,
    family = binomial,
    data = perognathus)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

The negative intercept is due to the much higher frequency of "failures" (the first level or *P. flavus*). The positive effect of weight means you've probably got a *P hispidus* in your pocket.


~~~r
summary(fit)
~~~
{:.input}
~~~

Call:
lm(formula = hindfoot_length ~ species_id + log(weight), data = animals)

Residuals:
     Min       1Q   Median       3Q      Max 
-24.0407  -0.6951   0.0352   0.7954  29.8038 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept)    8.4710     0.2222  38.127  < 2e-16 ***
species_idDM  19.5411     0.2164  90.316  < 2e-16 ***
species_idDO  18.8751     0.2189  86.234  < 2e-16 ***
species_idDS  31.3797     0.2320 135.262  < 2e-16 ***
species_idNL  13.0945     0.2382  54.967  < 2e-16 ***
species_idOL   4.7893     0.2176  22.011  < 2e-16 ***
species_idOT   5.0538     0.2129  23.743  < 2e-16 ***
species_idOX   5.4411     0.6553   8.303  < 2e-16 ***
species_idPB  10.3330     0.2144  48.196  < 2e-16 ***
species_idPE   5.2348     0.2137  24.499  < 2e-16 ***
species_idPF   2.7361     0.2101  13.023  < 2e-16 ***
species_idPH  10.0344     0.3277  30.622  < 2e-16 ***
species_idPI   7.3669     0.5336  13.807  < 2e-16 ***
species_idPL   5.3377     0.3119  17.115  < 2e-16 ***
species_idPM   5.5085     0.2152  25.601  < 2e-16 ***
species_idPP   7.2761     0.2102  34.623  < 2e-16 ***
species_idPX   4.7670     1.0036   4.750 2.05e-06 ***
species_idRF   3.5411     0.2637  13.430  < 2e-16 ***
species_idRM   2.9976     0.2090  14.343  < 2e-16 ***
species_idRO   1.9825     0.5327   3.722 0.000198 ***
species_idRX   4.2909     1.0034   4.276 1.90e-05 ***
species_idSF   9.7021     0.3100  31.298  < 2e-16 ***
species_idSH  11.1301     0.2535  43.909  < 2e-16 ***
species_idSO   8.7729     0.3093  28.364  < 2e-16 ***
log(weight)    2.1277     0.0380  55.998  < 2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 1.388 on 30713 degrees of freedom
  (4811 observations deleted due to missingness)
Multiple R-squared:  0.9789,	Adjusted R-squared:  0.9788 
F-statistic: 5.924e+04 on 24 and 30713 DF,  p-value: < 2.2e-16
~~~
{:.output}

[Return](#exercise-3)
{:.notes}

===

## Solution 4

`weight ~ (1 | plot_id) + sex`

[Return](#exercise-4)
{:.notes}
