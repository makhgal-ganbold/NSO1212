
## Test environments

* local ubuntu 20.04, R 3.6.3
* builder.r-hub.io (devtools::check_rhub())
* devtools::check_win_oldrelease(), devtools::check_win_release(), devtools::check_win_devel()

## R CMD check results

There were no ERRORs, WARNINGs or NOTEs when we checked with the functions devtools::check(), devtools::check_win_oldrelease(), devtools::check_win_release() and devtools::check_win_devel().

For the check with devtools::check_rhub(), there was only one note about elapsed time of example execution time for Windows only. The actual execution time (elapsed time) was 5.87 seconds. For other operating system, everything was OK.

## Downstream dependencies

There are currently no downstream dependencies for this package.
