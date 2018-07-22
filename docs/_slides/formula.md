---
---

## Formula Notation

The basic function for fitting a regression in R is the `lm()` function,
standing for linear model.



~~~r
> wt_len <- weight ~ hindfoot_length
> wt_len.fit <- lm(formula = wt_len,
+                  data = animals)
~~~
{:.input title="Console"}


The `lm()` function takes a formula argument and a data argument, and computes
the best fitting linear model (i.e. determine the optimum coefficients via
least-squared-error).
{:.notes}

===

### Formulas + Data

The implementation of `lm()` is a specific solution to a general problem: how
can a human easily write down a statistical model that a machine can interpret,
relate to data, and optimize through a given fitting procedure?
{:.notes}

The `lm()` function requires both careful human input and correct metadata:

1. Use a unquoted "formula" expression that mixes variable names and
algebra-like operators, to define a design matrix.
1. Check the variables used in the formula to complete the design matrix.
1. Compute the [linear least-squares
estimator](https://en.wikipedia.org/wiki/Linear_least_squares_(mathematics)) and
more.

Note that "the details" are left to the `lm()` function where possible. For
example, whether a variable is a factor or numeric is read from the data frame;
the formula does not distinguish between data types.
{:.notes}

===

## Formula Mini-language(s)
{:style="text-transform: none;"}

- "base R" function `lm()`
- "base R" function `glm()`
- [lme4](){:.rlib} function `lmer()`
- [lme4](){:.rlib} function `glmer()`
- [rstan](){:.rlib} models for Stan

Across different packages in R, the formula "mini-language" has evolved to
allow complex model specification and fitting. Each package adds syntax to the
formula or new arguments to the fitting function. On a far-distant branch of
this evolution is the Stan modeling language, which provides the greatest
flexibility but demands in return the most descriptive language.
{:.notes}
