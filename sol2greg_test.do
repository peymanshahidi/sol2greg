********************************************************************************
** Description:   	Test script for "sol2greg" command using a dataset of
**					  IRR to USD exchange rate provided by "d-learn.ir"
**					   (available at: https://d-learn.ir/p/usd-price)
** By:							     Peyman Shahidi
** Do-file Name:			       "sol2greg_test.do"
** Version Date:	  	       28 Tir 1402 - 19 July 2023
********************************************************************************
clear all
set more off


*===============================================================================
** Use case #1: input is single variable in string format
use "IRR_USD_exchangeRate", clear
cap program drop sol2greg

// convert Solar Hijri date variable "dateSolarHijri" to corresponding 
// Gregorian calendar date under variable name "my_dateGreg" using the
// "sol2greg" command
sol2greg dateSolarHijri, gen(my_dateGreg)
sort my_dateGreg

// sanity check: does generated Gregorian date variable "my_dateGreg" match 
// the original Gregorian date variable "dateGregorian" in dataset?
gen original_dateGreg = date(dateGregorian, "YMD")
format original_dateGreg %td
gen flag = 1 if my_dateGreg == original_dateGreg
count if missing(flag)
// no missing values --> all observations are the same --> sanity check passed!


*===============================================================================
** Use case #2: input consists of three variables in string (or numeric) formats
use "IRR_USD_exchangeRate", clear
cap program drop sol2greg

// split Solar Hijri date variable into separate year, month, day variables 
split dateSolarHijri, p("/") destring
rename dateSolarHijri1 solarYear
rename dateSolarHijri2 solarMonth
rename dateSolarHijri3 solarDay

// convert the Solar Hijri date variables created earlier to corresponding 
// Gregorian calendar date under variable name "my_dateGreg" using the
// "sol2greg" command
sol2greg solarYear solarMonth solarDay, gen(my_dateGreg)
sort my_dateGreg

// sanity check: does generated Gregorian date variable "my_dateGreg" match 
// the original Gregorian date variable "dateGregorian" in dataset?
gen original_dateGreg = date(dateGregorian, "YMD")
format original_dateGreg %td
gen flag = 1 if my_dateGreg == original_dateGreg
count if missing(flag)
// no missing values --> all observations are the same --> sanity check passed!
