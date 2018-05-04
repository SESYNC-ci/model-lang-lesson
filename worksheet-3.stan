data {
  int N;
  vector[N] hindfoot_length;
  int species_id[N];
  vector[N] log_weight;
  int M;
}
parameters {
  real beta0;
  vector[M] beta1;
  real beta2;
  real<lower=0> sigma;
  real<lower=0> sigma_spp;
}
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
