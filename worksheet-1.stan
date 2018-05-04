data {
  int N;
  vector[N] log_weight;
  vector[N] hindfoot_length;
}
parameters {
  real beta0;
  real beta1;
  real<lower=0> sigma;
}
model {
  vector[N] mu;
  mu = beta0 + log_weight * beta1;

  hindfoot_length ~ normal(mu, sigma);
  sigma ~ cauchy(0, 5);
  beta0 ~ normal(0, 10);
  beta1 ~ normal(0, 10);
}
