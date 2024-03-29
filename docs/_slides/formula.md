---
---

## Formula Notation

The developers of R created an approach to statistical analysis that is both
concise and flexible from the users perspective, while remaining precise and
well-specified for a particular fitting procedure.
{:.notes}

The researcher contemplating a new regression analysis faces three initial
challenges:

1. Choose the R function that implements a suitable fitting procedure.
1. Write the regression model using a formula expression combining
variable names with algebra-like operators.
1. Build a data frame with columns matching these variables that have suitable
data types for the chosen fitting procedure.

The formula expressions are usually very concise, in part because the function
chosen to implement the fitting procedure extracts much necessary information
from the provided data frame. For example, whether a variable is a factor or
numeric is not specified in the formula because it is specified in the data.
{:.notes}

===

## Formula Mini-languages
{:style="text-transform: none;"}

- "base R" function `lm()`
- "base R" function `glm()`
- [lme4](){:.rlib} function `lmer()`
- [lme4](){:.rlib} function `glmer()`

There are many R packages that are used for complex statistical modeling. Packages add additional syntax to the model formula or new
arguments to the fitting function. For example, the `lm` function allows only the simplest
kinds of expressions, while the [lme4](){:.rlib} package has its own
"mini-language" to allow specification of hierarchichal models.
{:.notes}

===

## Linear Models

The formula notation for linear models is a response variable left of a `~` and any number of predictors to its right. By default, the intercept, or constant, is fit in the model, so is not included in the formula. 

===

| Formula           | Description of right hand side |
|-------------------|-------------|
| `y ~ a`           | constant and one predictor |
| `y ~ a + b`       | constant and two predictors |
| `y ~ a + b + a:b` | constant and two predictors and their interaction |

===

The constant can be explicitly removed, although this is rarely
needed in practice. Assume an intercept is fitted unless its absence is explicitly noted.

| Formula      | Description of right hand side |
|--------------|-------------|
| `y ~ -1 + a` | one predictor with no constant |

===

There are also shorthand notations for higher-order interactions.

| Formula                | Description |
|------------------------|-------------|
| `y ~ a*b`              | all combinations of two variables  |
| `y ~ (a + b)^2`        | equivalent to `y ~ a*b` |
| `y ~ (a + b + ... )^n` | all combinations of all predictors up to order `n` |
