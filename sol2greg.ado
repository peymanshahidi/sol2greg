*******************************************************************************
** Description:    Conversion of Solar Hijri date to Gregorian date in Stata
** By:								   Peyman Shahidi
** Ado-file Name:					   "sol2greg.ado"
** Version Date:	  	          29 Tir 1402 - 20 July 2023
*******************************************************************************
*******************************************************************************
** The "sol2greg" command takes Solar Hijri date variable(s) as input and 
** produces corresponding Gregorian calendar dates in Stata %td datetime format
** under a user-specified variable name.
**
** Examples:
**
** 1. Suppose Solar Hijri date value "1390/6/1" is stored in variable "dateSolar" 
** and one wants to obtain the corresponding Gregorian calendar date "23aug2011" 
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
** 2. Three separate variables in year, month, day order. In this case each
**    input variable can be in either string or numeric format.
**
**
** Note 2:
** The Solar Hijri "year" value must be a 4-digit number. This is intentional 
** so that the user, rather than the program, makes the distinction between 
** 2-digit abbreviations of 13-- or 14-- Solar Hijri years (e.g., Solar Hijri 
** abbreviation "05" can correspond to either 1305 or 1405 in conventional use 
** cases). If all inputs are given in a 2-digit format (e.g., "90/6/1" in the 
** single-input use case of the program) the "sol2greg" command returns a syntax
** error. However, if some observations contain 4-digit year values while others
** contain 2-digit year values (e.g., one observation in the form of "90/6/1" 
** and another in the form of "1391/6/1") the command DOES NOT return a syntax
** error. In the latter case, it is assumed that the user has intentionally
** provided entries in such manner.
*******************************************************************************

program sol2greg
		version 14.0
		syntax varlist(min=1 max=3) [if/] [in/] [, SEParate(namelist min=3 max=3) ///
													STring(name) ///
													Datetime(name) ///
													Format(str)]
		tokenize `varlist'
		
		** return error if none of output options are specified
		if ("`string'" == "" & "`datetime'" == "" & "`separate'" == ""){
			display as error `"at least one output option must be specified"'
			exit 198
		}

quietly{
		** preserve original dataset and variable names
		preserve
		ds
		local original_vars `r(varlist)'
		
		** mask the in and if conditions
		if "`in'" != "" {
			keep in `in'
		}
		if "`if'" != "" {
			keep if `if'
		}
		
		
		** only keep Solar Hijri date variables for lower computation load
		keep `varlist'
		tempvar redundant
		duplicates tag `varlist', gen(`redundant') 
		bysort `varlist': keep if _n == _N
		
		
		/* start of handling inputs */
		** check if input Solar Hijri date variable is:
		** 1) a single variable in Stata datetime (%t*) or string format, or 
		** 2) three variables in form of year, month, day
		
		** if input is a single variable check whether it is
		** in Stata datetime (%t*) format or string format
		local bypass_conversion " " // when input is in %t* format 
									// no conversion is needed
		if "`varlist'" == "`1'" {
			
			** if single input variable is in datetime (%t*) format 
			** generate three separate variables for Gregorian year, month, day
			ds `varlist', has(format %t*)
			if "`r(varlist)'" == "`varlist'" {
				gen gy = year(`varlist')
				gen gm = month(`varlist')
				gen gd = day(`varlist')
				
				** define bypass_conversion = true to skip conversion later
				local bypass_conversion "True"
			}
			
			** if single input variable is not in datetime (%t*) format
			ds `varlist', has(format %t*)
			if "`r(varlist)'" != "`varlist'" {
				
				** return error if single input variable is not in string format 
				ds `varlist', has(type string)
				if "`r(varlist)'" != "`varlist'" {
					display as error ///
						`"single input must be in either datetime (%t*) or string ("year/month/day") format"'
					restore
					exit 198
				}
				
				** if single input variable is in string format generate three 
				** separate variables (knowing that the input is provided in the
				** year, month, day order)
				ds `varlist', has(type string)
				if "`r(varlist)'" == "`varlist'" {
					split `varlist', p("/" | "-" | "+"| ":" | "--" | " ") destring
				
					** assign local macros to Solar Hijri date variables
					rename `varlist'1 decomposed_sy
					rename `varlist'2 decomposed_sm
					rename `varlist'3 decomposed_sd
					
					** assign local macros to split Solar Hijri date variables
					local sy decomposed_sy
					local sm decomposed_sm
					local sd decomposed_sd
				}
			}
			
		}
		
		** if more than one variable is fed into the program 
		** proceed as if date decomposition is already done
		if "`varlist'" != "`1'" {
		
			** assign local macros to input Gregorian date variables
			local sy `1'
			local sm `2'
			local sd `3'
			
			** convert any input date variable in string format to numeric
			ds `varlist', has(type string)
			destring `r(varlist)', replace float					
		}	
		
		** if Solar Hijri year is not a 4-digit number return error
		if "`bypass_conversion'" != "True" {
			sum `sy'
			if `r(max)' < 100 {
				display as error "Solar Hijri year must be a 4-digit number" 
				restore
				exit 198
			}
		}
		/* end of handling inputs */
		
		
		/* start of Solar Hijri to Gregorian calendar conversion */
		if "`bypass_conversion'" != "True" {
			tempvar days temp leap ind dateG
			replace `sy' = `sy' + 1595
			gen `days' = -355668 + (365 * `sy') + (floor(`sy' / 33)) * 8 ///
						 + floor( ( mod(`sy', 33) + 3 ) / 4 ) + `sd'

			** specify firt half or second half of the year in Solar Hijri calendar
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

			** generate day in Gregorian calendar
			gen gd = `days' + 1
			drop `days'

			** determine if year is a leap year
			gen `leap' = cond( (mod(gy, 4) == 0 & mod(gy, 100) != 0) ///
								| mod(gy, 400) == 0, 1, 0)
					 
			** generate Gregorian month variable and 
			** indicator for days of month calculation
			gen gm = 1
			gen `ind' = 1
			
			** determine day and month in Gregorian calendar
			foreach i of numlist 31 28 31 30 31 30 31 31 30 31 30 31 {
				** indicator = 0 if Gregorian month has been 
				** determined in previous iterations
				replace `ind' = 0 if gd <= `i'

				** increment Gregorian month if indicator = 1:
				** subtract 29 (28) for February in leap (non-leap) years,
				** update month in Gregorian calendar
				replace gm = cond(`leap' == 1, cond(gd > 29, gm + 1, gm), ///
				cond(gd > 28, gm + 1, gm)) if `i' == 28 & `ind' == 1
				replace gm = cond(gd > `i', gm + 1, gm) if `i' != 28 & `ind' == 1
					
				** update day in Gregorian calendar
				replace gd = cond(`leap' == 1, cond(gd > 29, gd - 29, gd), ///
								cond(gd > 28, gd - 28, gd)) if `i' == 28 & `ind' == 1
				replace gd = cond(gd > `i', gd - `i', gd) if `i' != 28 & `ind' == 1
			}
			drop `ind' `leap'
			
			if "`varlist'" != "`1'" {
				replace `sy' = `sy' - 1595 // because we altered the Solar year
										   // variable at the beginning of conversion
			}
		}
		format gy gm gd %02.0f
		/* end of Solar Hijri to Gregorian calendar conversion */
		
		
		/* start of handling output(s) */
		** single-variable output in string ("year/month/day") format
		if "`string'" != "" {
			tempvar gy_str gm_str gd_str
			tostring gy, gen(`gy_str') usedisplayformat
			tostring gm, gen(`gm_str') usedisplayformat
			tostring gd, gen(`gd_str') usedisplayformat
			
			gen `string' = `gy_str' + "/" + `gm_str' + "/" + `gd_str'
			label variable `string' "Gregorian date"
			
			drop `gy_str' `gm_str' `gd_str'
		}
		
		** single-variable output in Stata datetime (%td) format
		if "`datetime'" != "" {
			gen `datetime' = mdy(gm, gd, gy)
			label variable `datetime' "Gregorian date"
			
			format `datetime' %td
			if "`format'" != "%td" {
				cap format `datetime' `format'
			}
		}
		
		** multiple-variable output in numeric format
		if "`separate'" != "" {
			label variable gy "Gregorian year"
			label variable gm "Gregorian month"
			label variable gd "Gregorian day"
			rename (gy gm gd) (`separate') // namelist given in (year month day) order
		}
		else {
			drop gy gm gd
		}
		/* end of handling output(s) */
		
		
		** merge Solar Hijri date variable(s) to the original dataset
		tempfile converted
		save `converted', replace
		restore
		merge m:1 `varlist' using `converted'
		drop _merge
		
		
		** remove auxiliary variables generated for calendar conversion
		** in the single-input case
		if "`varlist'" == "`1'" & "`bypass_conversion'" != "True" {
			drop `sy' `sm' `sd'
		}
}

end
