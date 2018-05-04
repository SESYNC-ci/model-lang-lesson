---
editor_options: 
  chunk_output_type: console
---

## Meet Stan

Stan is the name of a program that performs an entirely different kind of model fitting, and the Stan modelling language is yet another way of writing a "formula". Stan is similar to JAGS and BUGS: it is a "sampler", but does not use the Gibbs algorithm.

===

## Sampling vs. Fitting

The result of model fitting through `lm` and its descendents in R is an estimated coefficient coupled with the uncertainty in that estimate.

The results produced by Stan are tables of numbers with a column for each coefficient in the model. Each row represents an equally likely set of coefficients for the model, as judged by its resulting fit to the data.

===

## An example

The formulas we use previously to describe a "random intercepts" model are directly included in a Stan model file, along with necessary information on the data.

```
data {
  int N;
  int M;
  vector[N] hindfoot_length;
  int species_id[N];
  vector[N] log_weight;
}
```
{:.text-document title='{{ site.handouts[3] }}'}

===

The parameters section of the model defines the parameters for which
samples will be returned.

```
parameters {
  real beta0;
  vector[M] beta1;
  real beta2;
  real<lower=0> sigma;
  real<lower=0> sigma_spp;
}
```
{:.text-document title='{{ site.handouts[3] }}'}

===

The model section specifies all the probability distributions used in
the likelihood and the priors.

```
model {
  vector[N] mu;
  mu = beta0 + beta1[species_id] + log_weight * beta2;

  hindfoot_length ~ normal(mu, sigma);
  sigma ~ cauchy(0, 5);
  beta0 ~ normal(0, 5);
  beta1 ~ normal(0, sigma_spp);
  beta2 ~ normal(0, 5);
  sigma_spp ~ cauchy(0, 5);
}
```
{:.text-document title='{{ site.handouts[3] }}'}

===

# RStan

The [rstan](){:.rlib} package is a wrapper for sending data to the Stan program and getting back results.


~~~r
library(rstan)

stanimals <- animals %>%
    mutate(
        log_weight = log(weight),
        species_id = as.integer(factor(species_id))) %>%
    select(hindfoot_length, species_id, log_weight) %>%
    na.omit()
stanimals <- c(
    N = nrow(stanimals),
    M = max(stanimals$species_id),
    as.list(stanimals))

samp <- stan(file = 'worksheet-3.stan',
    data = stanimals,
    iter = 1000, chains = 4)
saveRDS(samp, 'stanimals.RDS')
~~~
{:.text-document title="{{ site.handouts[0] }}"}


## Parameter "samples"

An example `samp` output, saved to "RDS" after a long-running Stan job, is available in the handout's data folder. Each row represents an equally likely set of coefficients for the model, as judged by its resulting fit to the data.


~~~r
plot(samp, pars = c('beta0', 'beta2', 'sigma', 'sigma_spp'))
~~~
{:.input}



~~~r
plot(samp, pars = 'beta1')
~~~
{:.input}


===

## Using pre-compiled Stan Models

The function for ANOVA type models, fit with `lm` for the frequentist approach.


~~~r
fit <- stan_aov(
    hindfoot_length ~ log(weight),
    data = animals,
    prior = R2(location = 0.2, 'mean'),
    chains = 4, cores = 4, iter = 1000)
~~~
{:.input}


===

The function for logistic type models, fit with `glm` for the frequentist approach.


~~~r
t_prior <- student_t(df = 7, location = 0, scale = 2.5)
fit <- stan_glm(
    sex ~ log(hindfoot_length),
    data = animals, 
    family = binomial(link = "logit"), 
    prior = t_prior,
    prior_intercept = t_prior,  
    chains = 4, cores = 4, iter = 1000)
~~~
{:.input}


===

## Summary

- Several "formula" languages co-exist in R packages
  - Linear models and generalized linear models are similar
  - Mixed effects models use grouping to add "random effects"

- "Generalized" modeling functiongs add a `family` specification.

- Sampling with Stan lets you specify any structure and use any probability
  distribution. You pay a great cost in speed and difficulty, but that's going
  down with (rstanarm)[]{:.rlib}.
