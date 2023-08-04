********************************************************************************
** Description:   	Test script for "sol2greg" command using a dataset of
**					 historical IRR to USD exchange rate by "d-learn.ir"
**					   (available at: https://d-learn.ir/p/usd-price)
** By:							     Peyman Shahidi
** Do-file Name:			       "sol2greg_test.do"    
** Version Date:	  	     12 Mordad 1402 - 3 August 2023
********************************************************************************
clear all
graph drop _all
set more off
set scheme s1color


************************ Part 1: Get Required Materials ************************
** install "sol2greg" and copy the test dataset into current working directory
global my_url "https://raw.githubusercontent.com/peymanshahidi/sol2greg/master/"
cap ado uninstall sol2greg
cap net install sol2greg, from($my_url)
cap net get sol2greg, from($my_url)


****************** Part 2: Solar Hijri to Gregorian Conversion *****************
** Below three examples are given, each displaying use case of one input type

*===============================================================================
** Example 1: 
** Solar Hijri input is a single variable in string format ("year/month/day")
** all three types of output are concurrently generated through a single command
sysuse IRR_USD_histExRate, clear
sol2greg dateSolarHijri, separate(yearGregorian monthGregorian dayGregorian) ///
							string(gregDate_str) ///
							datetime(gregDate_datetime) format(%tC)
sort gregDate_datetime

*===============================================================================
** Example 2:
** Solar Hijri input is single variable in Stata datetime (%t*) format (i.e., 
** output of the "greg2sol" command in datetime format)
** Gregorian output is returned in three separate year, month, day variables

// Note: make sure you have installed the "greg2sol" command
cap net install greg2sol, ///
		from("https://raw.githubusercontent.com/peymanshahidi/greg2sol/master/")

sysuse IRR_USD_histExRate, clear
greg2sol dateGregorian, datetime(solarDate_datetime)
sol2greg solarDate_datetime, separate(yearGregorian monthGregorian dayGregorian)
sort yearGregorian monthGregorian dayGregorian

*===============================================================================
** Example 3: 
** Solar Hijri inputs are three variables provided in year, month, day order
** Gregorian output is to be returned under a single string variable
sysuse IRR_USD_histExRate, clear
split dateSolarHijri, p("/") destring
rename dateSolarHijri1 solarYear
rename dateSolarHijri2 solarMonth
rename dateSolarHijri3 solarDay
sol2greg solarYear solarMonth solarDay, st(gregDate_str)
sort gregDate_str

