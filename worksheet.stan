data {
  int N;
  int M;
  vector[N] log_weight;
  vector[N] hindfoot_length;
  int species_idx[N];
}
parameters {
  real beta0;
  vector[M] beta1;
  real beta2;
  real<lower=0> sigma;
  real<lower=0> sigma_spp;
}
transformed parameters {
  vector[N] mu;
//  for (i in 1:N)
  mu = beta0 + beta1[species_idx] + log_weight * beta2;
}
model {
  hindfoot_length ~ normal(mu, sigma);
  sigma ~ cauchy(0, 5);
  beta0 ~ normal(0, 10);
  beta1 ~ normal(0, sigma_spp);
  beta2 ~ normal(0, 10);
  sigma_spp ~ cauchy(0, 5);
}
