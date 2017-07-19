---
---

## Meet Stan

In Stan, the design matrix is not automatic.

## Sampling vs. Fitting


~~~r
library(rstan)

df <- animals %>%
  select(weight, hindfoot_length) %>%
  na.omit() %>%
  mutate(
    log_weight = log(weight),
    hindfoot_length = hindfoot_length) %>%
  select(-weight)
~~~

~~~
Error in select(., weight, hindfoot_length): could not find function "select"
~~~

~~~r
stanimals <- c(N = nrow(df), as.list(df))

fit <- stan(file = 'worksheet.stan',
            data = stanimals,
            iter = 2017, chains = 2)
~~~

~~~
In file included from /usr/local/lib/R/site-library/rstan/include/rstan/rstaninc.hpp:3:0,
                 from file51bead5fd.cpp:414:
/usr/local/lib/R/site-library/rstan/include/rstan/stan_fit.hpp: In function ‘int rstan::{anonymous}::command(rstan::stan_args&, Model&, Rcpp::List&, const std::vector<long unsigned int>&, const std::vector<std::__cxx11::basic_string<char> >&, RNG_t&)’:
/usr/local/lib/R/site-library/rstan/include/rstan/stan_fit.hpp:438:8: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<stan::io::var_context> init_context_ptr;
        ^~~~~~~~
In file included from /usr/include/c++/6/bits/locale_conv.h:41:0,
                 from /usr/include/c++/6/locale:43,
                 from /usr/local/lib/R/site-library/BH/include/boost/lexical_cast/detail/converter_lexical_streams.hpp:43,
                 from /usr/local/lib/R/site-library/BH/include/boost/lexical_cast/detail/converter_lexical.hpp:54,
                 from /usr/local/lib/R/site-library/BH/include/boost/lexical_cast/try_lexical_convert.hpp:42,
                 from /usr/local/lib/R/site-library/BH/include/boost/lexical_cast.hpp:32,
                 from /usr/local/lib/R/site-library/BH/include/boost/math/tools/convert_from_string.hpp:15,
                 from /usr/local/lib/R/site-library/BH/include/boost/math/constants/constants.hpp:13,
                 from /usr/local/lib/R/site-library/StanHeaders/include/stan/math/prim/scal/fun/constants.hpp:4,
                 from /usr/local/lib/R/site-library/StanHeaders/include/stan/math/rev/core/operator_unary_plus.hpp:7,
                 from /usr/local/lib/R/site-library/StanHeaders/include/stan/math/rev/core.hpp:34,
                 from /usr/local/lib/R/site-library/StanHeaders/include/stan/math/rev/mat.hpp:4,
                 from /usr/local/lib/R/site-library/StanHeaders/include/stan/math.hpp:4,
                 from /usr/local/lib/R/site-library/StanHeaders/include/src/stan/model/model_header.hpp:4,
                 from file51bead5fd.cpp:8:
/usr/include/c++/6/bits/unique_ptr.h:49:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /usr/local/lib/R/site-library/rstan/include/rstan/rstaninc.hpp:3:0,
                 from file51bead5fd.cpp:414:
/usr/local/lib/R/site-library/rstan/include/rstan/stan_fit.hpp:547:10: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     std::auto_ptr<rstan_sample_writer> sample_writer_ptr;
          ^~~~~~~~
In file included from /usr/include/c++/6/bits/locale_conv.h:41:0,
                 from /usr/include/c++/6/locale:43,
                 from /usr/local/lib/R/site-library/BH/include/boost/lexical_cast/detail/converter_lexical_streams.hpp:43,
                 from /usr/local/lib/R/site-library/BH/include/boost/lexical_cast/detail/converter_lexical.hpp:54,
                 from /usr/local/lib/R/site-library/BH/include/boost/lexical_cast/try_lexical_convert.hpp:42,
                 from /usr/local/lib/R/site-library/BH/include/boost/lexical_cast.hpp:32,
                 from /usr/local/lib/R/site-library/BH/include/boost/math/tools/convert_from_string.hpp:15,
                 from /usr/local/lib/R/site-library/BH/include/boost/math/constants/constants.hpp:13,
                 from /usr/local/lib/R/site-library/StanHeaders/include/stan/math/prim/scal/fun/constants.hpp:4,
                 from /usr/local/lib/R/site-library/StanHeaders/include/stan/math/rev/core/operator_unary_plus.hpp:7,
                 from /usr/local/lib/R/site-library/StanHeaders/include/stan/math/rev/core.hpp:34,
                 from /usr/local/lib/R/site-library/StanHeaders/include/stan/math/rev/mat.hpp:4,
                 from /usr/local/lib/R/site-library/StanHeaders/include/stan/math.hpp:4,
                 from /usr/local/lib/R/site-library/StanHeaders/include/src/stan/model/model_header.hpp:4,
                 from file51bead5fd.cpp:8:
/usr/include/c++/6/bits/unique_ptr.h:49:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
~~~

~~~
Warning in is.na(x): is.na() applied to non-(list or vector) of type 'NULL'
~~~

~~~
Warning in FUN(X[[i]], ...): data with name N is not numeric and not used
~~~

~~~
Warning in is.na(x): is.na() applied to non-(list or vector) of type 'NULL'
~~~

~~~
Warning in FUN(X[[i]], ...): data with name log_weight is not numeric and
not used
~~~

~~~
Warning in is.na(x): is.na() applied to non-(list or vector) of type 'NULL'
~~~

~~~
Warning in FUN(X[[i]], ...): data with name hindfoot_length is not numeric
and not used
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
print(fit)
~~~
{:.input}
~~~
Stan model 'worksheet' does not contain samples.
~~~
{:.output}
