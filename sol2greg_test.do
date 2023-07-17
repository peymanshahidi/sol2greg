********************************************************************************
** Description:   test script for "sol2greg" command using a dataset of
**					IRR to USD exchange rate provided by "d-learn.ir"
**					 (available at: https://d-learn.ir/p/usd-price)
** By:							 Peyman Shahidi
** File Name:				 	sol2greg_test.do
** Version Date:	  	    26 Tir 1402 - 17 July 2023
********************************************************************************
clear all
set more off



*===============================================================================
** Use case #1: input is single variable in string format
use "IRR_USD_exchangeRate", clear
cap program drop sol2greg

// convert Solar Hijri date variable "date_solarHijri" to corresponding 
// Gregorian calendar date under variable name "dateGreg" using the
// "sol2greg" command
sol2greg date_solarHijri, gen(dateGreg)
sort dateGreg

// sanity check: does generated Gregorian date variable "dateGreg" match 
// the original Gregorian date variable "date_gregorian" in dataset?
gen test_var = date(date_gregorian, "YMD")
format test_var %td
gen flag = 1 if dateGreg == test_var
sum flag
// min = max = 1 --> sanity check passed!



*===============================================================================
** Use case #2: input consists of three variables in string (or numeric) formats
use "IRR_USD_exchangeRate", clear
cap program drop sol2greg

// split Solar Hijri date variable into separate year, month, day variables 
split date_solarHijri, p("/") destring
rename date_solarHijri1 solarYear
rename date_solarHijri2 solarMonth
rename date_solarHijri3 solarDay

// convert the Solar Hijri date variables created earlier to corresponding 
// Gregorian calendar date under variable name "dateGreg" using the
// "sol2greg" command
sol2greg solarYear solarMonth solarDay, gen(dateGreg)
sort dateGreg

// sanity check: does generated Gregorian date variable "dateGreg" match 
// the original Gregorian date variable "date_gregorian" in dataset?
gen test_var = date(date_gregorian, "YMD")
format test_var %td
gen flag = 1 if dateGreg == test_var
sum flag
// min = max = 1 --> sanity check passed!
