I recently have been running into an issue while developing the package [taxa](https://github.com/ropensci/taxa). I am getting an error during tests, but not when running the same code from the console. After many failed efforts and much sorrow, I created a simple package called `bugtest` to function as a reprex and discovered some very strange behavior regarding `devtools::test()`. This issue report is the output of an Rmd file in the package source here:

<https://github.com/zachary-foster/bugtest>

``` r
library(bugtest)
```

`func_b` should look for data named `func_a`, which also happens to be the name of an exported function for the package, but is not the desired target for NSE. Here is the code for `func_b`:

    function(x) {
      my_data <- list("func_a" = letters[1:10])
      lazyeval::lazy_eval(lazyeval::lazy(x), data = my_data)
    }
    <environment: namespace:bugtest>

And here is `func_a`:

    function() {
      1:10
    }
    <environment: namespace:bugtest>

This seems to work as desired, and detect the `func_a` data in the `my_data` list given to the `data` option of `lazyeval` instead of the function `func_a`.

``` r
print(func_b(func_a))
```

    ##  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j"

However, it fails during testing, where the exact same code is run:

``` r
devtools::test()
```

    ## Loading bugtest

    ## Loading required package: testthat

    ## Testing bugtest

    ## error testing: function() {
    ##   1:10
    ## }
    ## <environment: namespace:bugtest>
    ## 
    ## 
    ## DONE ======================================================================

Here is the contents of the test file:

    library(bugtest)
    context("error testing")

    test_that("can reproduce bug", {
      print(func_b(func_a))
    })

The real weirdness is that after running the tests, running the same code again from the console causes the same bug as when it was run in the tests:

``` r
print(func_b(func_a))
```

    ## function() {
    ##   1:10
    ## }
    ## <environment: namespace:bugtest>

Therefore, running `devtools::test()` from the console is somehow altering the global environment or in some other way changing how NSE is working.
