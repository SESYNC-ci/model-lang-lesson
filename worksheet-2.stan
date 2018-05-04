data {
  int N;
  int<lower=0,upper=1> sex[N];
  vector[N] log_hindfoot_length;
}
parameters {
  real beta0;
  real beta1;
}
model {
  vector[N] mu;
  mu = beta0 + log_hindfoot_length * beta1;

  beta0 ~ normal(0, 5);
  beta1 ~ normal(0, 5);
  sex ~ bernoulli_logit(mu);
}
