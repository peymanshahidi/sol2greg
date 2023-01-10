*******************************************************************************
** title: 	  	Conversion of Solar Hijri calendar to Gregorian calendar
** by:								Peyman Shahidi
** ado-file name:					 sol2greg.ado
** version date:	  	    	1399/03/26 - 15/06/2020
*******************************************************************************
*******************************************************************************
** This command takes date from Solar Hijri calendar in string format and 
** returns the corresponding Gregorian calendar date in Stata date-time format 
** via a user-specified variable name.
*******************************************************************************
*******************************************************************************
** Note 1: 
** Solar Hijri date inputs must be provided in a string with the following format:
** "year/month/day", e.g., "1390/6/1". 
** However, instead of "/", your entry may contain any of these characters:
** "/", "-", "+", ":",  "--", " "
** For instance, "1390-6-1" and "1390:6+1" are both treated as "1390/6/1".
**
** Note 2:
** The Solar Hijri 'year' must be a 4-digit number. Otherwise the command returns a 
** syntax error. 
** For example, for input "90/6/1" this command returns a syntax error.
*******************************************************************************
*******************************************************************************
** Example:
** Suppose "1390/6/1" is stored in a variable named `date' and one wants to 
** obtain `23aug2013' (the corresponding date in Gregorian calendar in %td 
** format) in a variable named `Greg_date'. The following command does the job:
**
** sol2greg date, gen(Greg_date)
**
*******************************************************************************

program sol2greg
		version 14.1
		syntax varlist(min=1 max=1 string) [if/] , gen(name)

quietly{
		// preserving the dataset in memory
		preserve
		
		// masking the if condition and keeping only calendar dates
		if "`if'" != "" {
						 keep if `if'
		}
		keep `varlist'
		
		tempvar dup days temp leap ind dateG
		
		// droping duplicate dates in Solar Hijri entries
		duplicates tag `varlist', gen(`dup') 
		bysort `varlist': keep if _n == _N
		drop `dup'
		
		// convert string input into numeric variables
		
		split `varlist', p("/" | "-" | "+"| ":" | "--" | " ") destring
		local jy `varlist'1
		local jm `varlist'2
		local jd `varlist'3
			
		
		if `jy' < 100 {
						display as error "year variable out of range" 
						exit 198
		}
		
		** start of Solar Hijri to Gregorian conversion
		
		
		replace `jy' = `jy' + 1595
		gen `days' = -355668 + (365 * `jy') + (floor(`jy' / 33)) * 8 ///
					 + floor( ( mod(`jy', 33) + 3 ) / 4 ) + `jd'

		// specify firt half or second half of the year in Solar Hijri calendar
		replace `days' = cond(`jm' < 7, `days' + (`jm'-1)* 31, ///
						 `days' + ((`jm' - 7) * 30) + 186)
				  
		gen gy = 400 * floor(`days' / 146097)
		replace `days' = mod(`days', 146097)
 
		gen `temp' = `days'
		replace `days' = cond(`temp' > 36524, `days' - 1, `days')
		replace gy = cond(`temp' > 36524, gy + 100 * floor(`days'  / 36524), gy)
		replace `days' = cond(`temp' > 36524, mod(`days', 36524), `days')
		replace `days' = cond(`temp' > 36524 & `days' >= 365, `days' + 1, `days')
		drop `temp'
				
		replace gy = gy + 4 * floor(`days' / 1461)
		replace `days' = mod(`days', 1461)
		replace gy = cond(`days' > 365, gy + floor((`days' - 1)/365), gy)
		replace `days' = cond(`days' > 365, mod((`days' - 1), 365), `days')

		// create day in Gregorian year
		gen gd = `days' + 1
		drop `days'

		// determine leap years
		gen `leap' = cond( (mod(gy, 4) == 0 & mod(gy, 100) != 0) ///
							| mod(gy, 400) == 0, 1, 0)
				 
		// initialization of Gregorian months and indicator for day calculation
		gen gm = 1
		gen `ind' = 1

		// determine day and month in Gregorian year
		foreach i of numlist 31 28 31 30 31 30 31 31 30 31 30 31 {
			// indicator = 0 if the month has been 
			// determined in previous iterations
			replace `ind' = 0 if gd <= `i'

			// increase Gregorian months if indicator = 1:
			// subtract 28 for February unless in a leap year,
			// subtract 29 for February in leap years
			// update months
			replace gm = cond(`leap' == 1, cond(gd > 29, gm + 1, gm), ///
			cond(gd > 28, gm + 1, gm)) if `i' == 28 & `ind' == 1
			replace gm = cond(gd > `i', gm + 1, gm) if `i' != 28 & `ind' == 1
				
			// update days
			replace gd = cond(`leap' == 1, cond(gd > 29, gd - 29, gd), ///
							cond(gd > 28, gd - 28, gd)) if `i' == 28 & `ind' == 1
			replace gd = cond(gd > `i', gd - `i', gd) if `i' != 28 & `ind' == 1
		}
		drop `jy' `jm' `jd' `ind' `leap'
		** end of Solar Hijri to Gregorian conversion
		
		// creating variable with %td format
		tostring gy gm gd, replace
		gen `dateG' = gy + "/" +gm + "/" +gd
		drop gy gm gd
		gen `gen' = date(`dateG',"YMD")
		drop `dateG'
		format `gen' %td
		
		// saving the calculations into temporary file "converted"
		tempfile converted
		save `converted', replace
		restore
		
		// merge the results into the preserved dataset
		merge m:1 `varlist' using `converted'
		drop _merge
}

end
