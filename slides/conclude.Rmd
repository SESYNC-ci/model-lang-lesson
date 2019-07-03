---
---

## A little advice

- Don't *start* with generalized linear mixed models! Work your way up through
  1. `lm()`
  1. `glm()`
  1. `lmer()`
  1. `glmer()`
  1. `stan_lm()`

- Take time to understand the `summary()`---the hazards of secondary data compel
  you! The vignettes for [lme4](){:.rlib} provide excellent documentation.

===

- When all else fails with lme4, ask on [Cross Validated] (and [Ben Bolker] very
  well might answer).

- When all else fails with Stan, ask the [Stan users/devs] community.

[Cross Validated]: https://stats.stackexchange.com/
[Ben Bolker]: https://stats.stackexchange.com/users/2126/ben-bolker
[Stan users/devs]: https://discourse.mc-stan.org/
