# Linear models

... <- read.csv(...,
  na.strings = '')
fit <- ...(
  ...,
  ...)

# Metadata matters

fit <- lm(
  ...,
  data = animals)

# Exercise 1

...

# GLM families

fit <- ...(...,
  ...,
  data = animals)

# Exercise 2

...

# Logistic regression

animals$sex <- ...(...)
fit <- glm(...,
  ...,
  data = animals)

# Exercise 3

...

# Random intercept

library(...)
fit <- ...(
  ...,
  data = animals)

# Exercise 4

...

# Random slope

fit <- lmer(
  hindfoot_length ~ 
    ...,
  data = animals)
