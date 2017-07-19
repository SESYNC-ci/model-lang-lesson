data {
  int<lower=0> N;
  vector[N] log_weight;
  vector[N] hindfoot_length;
} 
parameters {
  real beta0;
  real beta1;
  real<lower=0> sigma;
} 
model {
  log_weight ~ normal(beta0 + hindfoot_length * beta1, sigma);
}
