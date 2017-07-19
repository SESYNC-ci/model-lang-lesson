---
---

## R's formula notation

The basic function for fitting a regression in R is the `lm` function, standing for linear model.


~~~r
wt_len <- weight ~ hindfoot_length
wt_len.fit <- lm(formula = wt_len, data = animals)
~~~
{:.input}

The `lm` function uses the formula, picking up information from the data types in `portal` to do so, to return a fitted model (i.e. one with estimated coefficients).

===

## Mini-language

The implementation of `lm` is a specific solution to a general problem: how can a human easily write down a statistical model that a machine can interpret, relate to data, and optimize through a given fitting procedure?

For the `lm` function, the answers are:

1. Use a unquoted "formula" expression, mixing variable names and algebra-like operators, that maps to a design matrix.
1. Search within a specified data frame for variables used in the formula to complete the design matrix.
1. Compute the [linear least-squares estimator](https://en.wikipedia.org/wiki/Linear_least_squares_(mathematics)) and more.

Note that "the details" are left to the `lm` function where possible. For example, whether a variable is a factor or numeric is read from the data frame; the formula does not need to distinguish between data types.

===

## Mini-language

Across different packages in R, this formula "mini-language" has evolved to allow complex model specification. Each one adds syntax to the formula or new arguments to the fitting function. On a far-distant branch of this evolution is the Stan modeling language, which provides the greatest flexibility but, in exchange, demands the most descriptive language.
