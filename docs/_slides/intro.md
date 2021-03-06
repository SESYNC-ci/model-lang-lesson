---
---

## Lesson Objectives

- Learn several functions and packages for statistical modeling
- Understand the "formula" part of model specification
- Introduce increasingly complex, still "linear", regression models

===

## Lesson Non-objectives

*Pay no attention to these very important topics.*
{:.notes}

- Experimental/sampling design
- Model validation
- Hypothesis tests
- Model comparison

===

## Specific Achievements

- Write a `lm` formula with an interaction term
- Use a non-gaussian family in the `glm` function
- Add a "random effect" to a `lmer` formula

===

## Dataset

The dataset you will plot is an example of Public Use Microdata Sample (PUMS)
produced by the US Census Beaurea.



~~~r
library(readr)
library(dplyr)

person <- read_csv(
  file = 'data/census_pums/sample.csv',
  col_types = cols_only(
    AGEP = 'i',  # Age
    WAGP = 'd',  # Wages or salary income past 12 months
    SCHL = 'i',  # Educational attainment
    SEX = 'f',   # Sex
    OCCP = 'f',  # Occupation recode based on 2010 OCC codes
    WKHP = 'i')) # Usual hours worked per week past 12 months
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


This CSV file contains individuals’ anonymized responses to the 5 Year American
Community Survey (ACS) completed in 2017. There are over a hundred variables
giving individual level data on household members income, education, employment,
ethnicity, and much more. The [technical documentation] provided the data
definitions quoted above in comments.
{:.notes}

===

Collapse the education attainment levels for this lesson, and remove non
wage-earners as well as the "top coded" individuals whose income is annonymized.



~~~r
person <- within(person, {
  SCHL <- factor(SCHL)
  levels(SCHL) <- list(
    'Incomplete' = c(1:15),
    'High School' = 16,
    'College Credit' = 17:20,
    'Bachelor\'s' = 21,
    'Master\'s' = 22:23,
    'Doctorate' = 24)}) %>%
  filter(
    WAGP > 0,
    WAGP < max(WAGP, na.rm = TRUE))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


[technical documentation]: https://www.census.gov/programs-surveys/acs/technical-documentation/pums/documentation.html
