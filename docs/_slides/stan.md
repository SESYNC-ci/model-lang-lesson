---
---

## Meet Stan

Stan is the name of a program that performs an entirely different kind of model
fitting, and the Stan modelling language is yet another way of writing a
"formula". Stan is similar to JAGS and BUGS---it is a "sampler", but does not use
the Gibbs algorithm.

===

### Sampling vs. Fitting

The result of model fitting through `lm` and its descendents in R is an estimated coefficient coupled with the uncertainty in that estimate.

![ ]({{ site.baseurl }}/images/stan/unnamed-chunk-1-1.png)
{:.captioned}

The results produced by Stan are tables of numbers with a column for each coefficient in the model. Each row represents an equally likely set of coefficients for the model, as judged by its resulting fit to the data.
{:.notes}

===

### An Example

The formulas we use previously to describe a "random intercepts" model are
directly included in a Stan model file, along with necessary information on the
data.

```
data {
  int N;
  int M;
  vector[N] hindfoot_length;
  int species_id[N];
  vector[N] log_weight;
}
```
{:.text-document title='{{ site.handouts[1] }}'}

===

The parameters section of the model defines the parameters for which samples
will be returned.

```
parameters {
  real beta0;
  vector[M] beta1;
  real beta2;
  real<lower=0> sigma0;
  real<lower=0> sigma1;
}
```
{:.text-document title='{{ site.handouts[1] }}'}

===

The model section specifies all the probability distributions used in the
likelihood and the priors.

```
model {
  vector[N] mu;

  mu = beta0 + beta1[species_id] + beta2 * log_weight;
  hindfoot_length ~ normal(mu, sigma0);
  beta1 ~ normal(0, sigma1);

  beta0 ~ normal(0, 5);
  beta2 ~ normal(0, 5);
  sigma0 ~ cauchy(0, 5);
  sigma1 ~ cauchy(0, 5);
}
```
{:.text-document title='{{ site.handouts[1] }}'}

===

### RStan

The [rstan](){:.rlib} package is a wrapper for sending data to the Stan program
and getting back results.

===



~~~r
library(dplyr)

stanimals <- animals %>%
    select(hindfoot_length, species_id, weight) %>%
    na.omit() %>%
    mutate(
        log_weight = log(weight),
        species_id = as.integer(factor(species_id))) %>%
    select(-weight)
stanimals <- c(
    N = nrow(stanimals),
    M = max(stanimals$species_id),
    as.list(stanimals))
~~~
{:.text-document .no-eval title="{{ site.handouts[0] }}"}


===

The `stan` function reads the model file, compiles an hidden executable based on the model and data, runs it and reads the results back into R.



~~~r
library(rstan)
samp <- stan(file = 'worksheet.stan',
    data = stanimals,
    iter = 1000, chains = 2, cores = 2)
saveRDS(samp, 'stanimals.RDS')
~~~
{:.text-document .no-eval title="{{ site.handouts[0] }}"}



===

### Parameter Inference

An example `samp` output, saved to "RDS" after a long-running Stan job, is
available in the handout's data folder. Each row represents an equally likely
set of coefficients for the model, as judged by its resulting fit to the data.



~~~r
> plot(samp, pars = c('beta0', 'beta2', 'sigma0', 'sigma1'))
~~~
{:.input title="Console"}


~~~
ci_level: 0.8 (80% intervals)
~~~
{:.output}


~~~
outer_level: 0.95 (95% intervals)
~~~
{:.output}
![ ]({{ site.baseurl }}/images/stan/unnamed-chunk-5-1.png)
{:.captioned}

===

The "random intercepts" due to species_id are also parameters in the
model---which merely claimed they are normally distributed with variance
`sigma1`.



~~~r
> plot(samp, pars = 'beta1')
~~~
{:.input title="Console"}


~~~
ci_level: 0.8 (80% intervals)
~~~
{:.output}


~~~
outer_level: 0.95 (95% intervals)
~~~
{:.output}
![ ]({{ site.baseurl }}/images/stan/unnamed-chunk-6-1.png)
{:.captioned}

Perhaps we should revisit that claim, and choose a asymmetric distribution.
{:.notes}

===

### Pre-compiled Stan

Sampling with Stan lets you specify any structure and use any probability
distribution. You pay quite a cost in speed and difficulty, but both are going
down with [rstanarm](){:.rlib}.

===

The pre-compiled Stan analog of the example above takes a similar model formula
as [lme4](){:.rlib}, the usual data frame, and adds "default" priors.



~~~r
library(rstanarm)
fit <- stan_lmer(
    hindfoot_length ~ (1 | species_id) + log(weight),
    data = animals,
    chains = 2, cores = 2, iter = 1000)
~~~
{:.text-document .no-eval title="{{ site.handouts[0] }}"}


The `stan_glmer` function allows you to additionally specify a family, same as the `glm` function employed above.
{:.notes}

===

