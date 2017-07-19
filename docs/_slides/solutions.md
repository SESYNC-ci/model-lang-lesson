---
---

## Solutions

===

## Solution 3


~~~r
species <- read.csv('data/species.csv')
df <- animals %>%
  inner_join(species, c('species_id' = 'id')) %>%
  filter(genus == 'Perognathus')
~~~
{:.input}
~~~
Error in inner_join(., species, c(species_id = "id")): could not find function "inner_join"
~~~
{:.input}
~~~r
df$species_id <- factor(df$species_id)
~~~
{:.input}
~~~
Error in df$species_id: object of type 'closure' is not subsettable
~~~
{:.input}
~~~r
summary(glm(species_id ~ weight, family = binomial, data = df))
~~~
{:.input}
~~~
Error in terms.formula(formula, data = data): 'data' argument is of the wrong type
~~~
{:.output}

[Return](#exercise-3)
{:.notes}
