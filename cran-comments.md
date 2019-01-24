## Resubmission

* Author and Maintainer Name:
  Format of authors name was changed to "Title case".
* DESCRIPTION:
  1. Description was become more informative and definitely.
  2. Added the abbreviation NSO, an explanation for "1212" and features of functions.
* Function Help Pages:
  1. More informative titles and descriptions were added.
  2. The return value sections were re-formatted by using the environment 'describe' to remove the dashes and spaces.
  3. Misspellings in the help pages were corrected.

## Test environments

* local ubuntu 18.10, R 3.5.2
* win-builder (devel and release)

## R CMD check results

There were no ERRORs, WARNINGs or NOTEs when we checked with the function devtools::check().

It was developed on R 3.5.1 and checked on R 3.5.2. So devtools::check_win_oldrelease() and some devtools::check_rhub() checks for R 3.4.x were failed. All other checks were passed successfully.

## Downstream dependencies

There are currently no downstream dependencies for this package. Because it's the 1st release.
