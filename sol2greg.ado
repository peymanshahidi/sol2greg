*******************************************************************************
** Description:    Conversion of Solar Hijri date to Gregorian date in Stata
** By:								   Peyman Shahidi
** Ado-file Name:					   "sol2greg.ado"
** Version Date:	  	          28 Tir 1402 - 19 July 2023
*******************************************************************************
*******************************************************************************
** The "sol2greg" command takes Solar Hijri date variable(s) as input and 
** produces corresponding Gregorian calendar dates in Stata %td datetime format
** under a user-specified variable name.
**
** Examples:
**
** 1. Suppose Solar Hijri date value "1390/6/1" is stored in variable "dateSolar" 
** and one wants to obtain the corresponding Gregorian calendar date "23aug2013" 
** under a new variable called "dateGreg" in Stata %td datetime format. The 
** following command does this conversion:
**
**
** sol2greg dateSolar, gen(dateGreg)
**
**
** 2. If the Solar Hijri input date value "1390/6/1" is stored in three separate
** variables "yearSolar" (1390), "monthSolar" (6), "daySolar" (1), and the 
** output is to be returned under a variable called "dateGreg", one can use the 
** following command for conversion:
**
**
** sol2greg yearSolar monthSolar daySolar, gen(dateGreg)
**
**
*******************************************************************************
*******************************************************************************
** Note 1: 
** The "sol2greg" command can manage two types of inputs:
** 1. A single string variable in the "year/month/day" format (e.g., "1390/6/1") 
**    where the command is able to flexibly handle the following delimiters:
**    "/", "-", "+", ":",  "--", " " (white space) 
**    For instance, "1390-6-1" and "1390:6+1" are treated similar to "1390/6/1".
** 2. Three separate variables in the (year, month, day) order. In this case 
**    each input variable can be in either string or numeric format.
**
**
** Note 2:
** The Solar Hijri "year" must be a 4-digit number. This is intentional so that
** the user, rather than the program, makes the distinction between 2-digit 
** values corresponding to abbreviation of either 13-- or 14-- Solar Hijri years
** (e.g., Solar Hijri year value "05" can correspond to either 1305 or 1405 in 
** conventional use cases). If all inputs are given in a 2-digit format (e.g., 
** "90/6/1" in the single-input use case of the program) the "sol2greg" command
** returns a syntax error. However, if some observations contain 4-digit year
** values while others contain 2-digit year values (e.g., one observation in the
** form of "90/6/1" and another in the form of "1391/6/1") the command DOES NOT 
** return a syntax error. In the latter case, it is assumed that the user has 
** intentionally provided entries in such manner.
*******************************************************************************

program sol2greg
		version 14.1
		syntax varlist(min=1 max=3) [if/], gen(name)
		
		// since gen(name) is required in the command it is possible that the
		// `varlist' contains the comma typed before last variable if there's no
		// space between the entries 
		
		// use tokenize to remove possible extra comma
		tokenize `varlist'

quietly{
		// preserve dataset fed into the command in memory
		preserve
		
		// mask the if condition
		if "`if'" != "" {
			keep if `if'
		}
		
		// keep only the calendar date variables
		keep `varlist'
		
		// drop duplicates in Solar Hijri input dates
		tempvar dup
		duplicates tag `varlist', gen(`dup') 
		bysort `varlist': keep if _n == _N
		drop `dup'
		
		
		** check if input Gregorian date variable is
		** a single variable in string format, or
		** three variables in form of year, month, day
		
		// if only 1 variable is fed into the program check if it is
		// in string format. if so, split into three separate variables
		if "`varlist'" == "`1'" {
			ds `varlist', has(type string)
			
			// display error if single input is not in %t* format
			if "`r(varlist)'" != "`varlist'" {
				display as error ///
					"single Solar Hijri date variable must be in string format"
				restore
				exit 198
			}
			
			// convert input Solar Hijri string into numeric variables and
			// assign local macros
			split `varlist', p("/" | "-" | "+"| ":" | "--" | " ") destring
			local sy `varlist'1
			local sm `varlist'2
			local sd `varlist'3
		}
		
		// if more than 1 variable is fed into the program 
		// proceed as if date decomposition is done already
		if "`varlist'" != "`1'" {
			// assign local macros to input Gregorian date variables
			local sy `1'
			local sm `2'
			local sd `3'
			
			// convert any date variable in string format to numeric 
			ds `varlist', has(type string)
			destring `r(varlist)', replace float
		}
		** end of input variable check	
		
		
		
		// display error if Solar Hijri year is not given in 4 digits
		sum `sy'
		if `r(max)' < 100 {
				display as error "Solar Hijri year must be a 4-digit number" 
				restore
				exit 198
		}
		
		
		
		** start of Solar Hijri to Gregorian conversion
		tempvar days temp leap ind dateG
		replace `sy' = `sy' + 1595
		gen `days' = -355668 + (365 * `sy') + (floor(`sy' / 33)) * 8 ///
					 + floor( ( mod(`sy', 33) + 3 ) / 4 ) + `sd'

		// specify firt half or second half of the year in Solar Hijri calendar
		replace `days' = cond(`sm' < 7, `days' + (`sm'-1)* 31, ///
						 `days' + ((`sm' - 7) * 30) + 186)
				  
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

		// generate day in Gregorian calendar
		gen gd = `days' + 1
		drop `days'

		// determine if year is a leap year
		gen `leap' = cond( (mod(gy, 4) == 0 & mod(gy, 100) != 0) ///
							| mod(gy, 400) == 0, 1, 0)
				 
		// generate Gregorian month variable and indicator for days of month calculation
		gen gm = 1
		gen `ind' = 1
		
		// determine day and month in Gregorian calendar
		foreach i of numlist 31 28 31 30 31 30 31 31 30 31 30 31 {
			// indicator = 0 if Gregorian month has been 
			// determined in previous iterations
			replace `ind' = 0 if gd <= `i'

			// increase Gregorian month if indicator = 1:
			// subtract 29 (28) for February in leap (non-leap) years,
			// update month in Gregorian calendar
			replace gm = cond(`leap' == 1, cond(gd > 29, gm + 1, gm), ///
			cond(gd > 28, gm + 1, gm)) if `i' == 28 & `ind' == 1
			replace gm = cond(gd > `i', gm + 1, gm) if `i' != 28 & `ind' == 1
				
			// update day in Gregorian calendar
			replace gd = cond(`leap' == 1, cond(gd > 29, gd - 29, gd), ///
							cond(gd > 28, gd - 28, gd)) if `i' == 28 & `ind' == 1
			replace gd = cond(gd > `i', gd - `i', gd) if `i' != 28 & `ind' == 1
		}
		drop `ind' `leap'
		
		if "`varlist'" != "`1'" {
			replace `sy' = `sy' - 1595 // because we altered the Solar year
									   // variable at the beginning of conversion
		}
		** end of Solar Hijri to Gregorian conversion
		
		
		
		// generate Gregorian date variable in %td format
		gen `gen' = mdy(gm, gd, gy)
		format `gen' %td
		label variable `gen' "Gregorian date"
		drop gy gm gd
		
		if "`varlist'" == "`1'" {
			drop `sy' `sm' `sd'
		}
		
		// save output of conversion in a temporary file named "converted"
		tempfile converted
		save `converted', replace
		
		// merge Gregorian date variable to the main dataset fed into the command
		restore
		merge m:1 `varlist' using `converted'
		drop _merge
}

end
