********************************************************************************
** title: 		 test run for sol2greg command using a sample of
**							 IRR to USD exchange rate

** by:							 Peyman Shahidi

** file name:				 	test_sol2greg.do

** version date:	  	    1399/02/29 - 18/05/2020
*******************************************************************************
clear all
set more off

use "sol2greg_test", clear
cap program drop sol2greg
sol2greg date, gen(dateGreg)
