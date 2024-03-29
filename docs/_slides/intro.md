---
---

## Lesson Objectives

- Learn functions and packages for statistical modeling in R
- Understand "formulas" of model specification
- Introduce simple and complex "linear" regression models

===

## Specific Achievements

- Write a simple linear formula using `lm` function.
- Write a linear formula with a non-gaussian family using the `glm` function.
- Add a "random effect" into a linear formula using the a `lmer` package

===

## Lesson Non-objectives

The main objective of this lesson is coding of linear models in R and does assume some introductory knowledge of statistics and linear models. This lesson does *not* cover the following topics related to statistical modeling. These should be considered carefully when analyzing data.
{:.notes}

- Experimental/sampling design
- Model validation
- Hypothesis tests
- Model comparison

===

## Dataset

In this lesson, you will use Public Use Microdata Sample (PUMS) data collected by the US Census Bureau. This CSV file contains individuals’ anonymized responses to the 5 Year American Community Survey (ACS) completed in 2017. There are over a hundred variables giving individual level data on household members income, education, employment, ethnicity, and much more. The [technical documentation] for the PUMS data includes a data dictionary, explaining the codes used for the variable, such as education attainment, and other information about the dataset.
{:.notes}

First, load the data file, including only a small subset of the variables from the full ACS survey. 

===



~~~r
library(readr)
library(dplyr)

pums <- read_csv(
  file = 'data/census_pums/sample.csv',
  col_types = cols_only(
    AGEP = 'i',  # Age
    WAGP = 'd',  # Wages or salary income past 12 months
    SCHL = 'i',  # Educational attainment
    SEX = 'f',   # Sex
    MAR = 'f', # Marital status
    HINS1 = 'f', # has insurance through employer
    WKHP = 'i')) # Usual hours worked per week past 12 months
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


The [readr](){:.rlib} package gives additional flexibility and speed over the
base R `read.csv` function. The CSV contains 4 million rows, equating to several
gigabytes, so a sample suffices while developing ideas for visualization.
{:.notes}

The [dplyr](){:.rlib} package is also used in this lesson to manipulate the data frames.
{:.notes}

===

In the ACS data, educational attainment, `SCHL`, is coded numerically from 1-24. We can collapse the education attainment levels for this lesson into factors. 

===

We can also remove all non wage-earners (where wages is equal to 0) and the "top coded" individuals, representing a group of very high earners, using the `filter` function from the [dplyr](){:.rlib} package. 

===



~~~r
pums <- within(pums, {
  SCHL <- factor(SCHL)
  levels(SCHL) <- list(
    'Incomplete' = c(1:15),
    'High School' = 16:17,
    'College Credit' = 18:20,
    'Bachelor\'s' = 21,
    'Master\'s' = 22:23,
    'Doctorate' = 24)}) %>%
  filter(
    WAGP > 0,
    WAGP < max(WAGP, na.rm = TRUE))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


[technical documentation]: https://www.census.gov/programs-surveys/acs/technical-documentation/pums/documentation.html
