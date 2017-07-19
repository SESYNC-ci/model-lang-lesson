---
---

## Meet Stan

Stan is the name of a program that performs an entirely different kind of model fitting, and the Stan modelling language is yet another way of writing a "formula". Stan is similar to JAGS and BUGS: it is a "sampler", but does not use the Gibbs algorithm.

===

## Sampling vs. Fitting

The result of model fitting through `lm` and its descendents in R is an estimated coefficient coupled with the uncertainty in that estimate.

The results produced by Stan are tables of numbers with a column for each coefficient in the model. Each row represents an equally likely set of coefficients for the model, as judged by its resulting fit to the data.

===

## An example

The formulas we use previously to describe a "random intercepts" model are directly included in a Stan formula.

```
data {
  int N;
  vector[N] log_weight;
  vector[N] hindfoot_length;
  int species_id[N];
  int M;
} 
parameters {
  real beta0;
  vector[M] beta1;
  real beta2;
  real<lower=0> sigma;
  real<lower=0> sigma_genus;
}
transformed parameters {
  vector[N] mu;
  for (i in 1:N)
    mu = beta0 + beta1[species_id]+ hindfoot_length * beta2;
}
model {
  log_weight ~ normal(mu, sigma);
  beta0 ~ normal(0, 10);
  beta1 ~ normal(0, sigma_genus);
  beta2 ~ normal(0, 10);
  sigma_genus ~ cauchy(0, 5);
}
```
{:.text-document title='worksheet.stan'}

===

# RStan

The [rstan](){:.rlib} package is a wrapper for sending data to the Stan program and getting back results.


~~~r
library(rstan)

stanimals <- animals %>%
  select(weight, species_id, hindfoot_length) %>%
  na.omit() %>%
  mutate(log_weight = log(weight),
         species_idx = as.integer(factor(species_id))) %>%
  select(-weight, -species_id)
stanimals <- c(
  N = nrow(stanimals),
  M = max(stanimals$species_idx),
  as.list(stanimals))

samp <- stan(file = 'worksheet.stan',
             data = stanimals,
             iter = 1000, chains = 3)
saveRDS(samp, 'stanimals.RDS')
~~~
{:.text-document title="worksheet.R"}

===

## Summary

- Several "formula" languages co-exist in R packages
  - Linear models and generalized linear models are similar
  - Mixed effects models use grouping to add "random effects"

- "Generalized" modeling functiongs add a `family` specification.

- Sampling with Stan lets you specify any structure and use any probability distribution. You pay a great cost in speed and difficulty.
