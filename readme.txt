*******************************************************************************
** Instructions for "sol2greg" command by Peyman Shahidi **
** Last updated: Oct 10, 2020
*******************************************************************************


This command takes date from solali calendar in string format and returns
the corresponding Gregorian calendar date in Stata date-time format via a 
user-specified variable name.


Example:
Suppose "1390/6/1" is stored in a variable named `date' and one wants to 
obtain `23aug2013' (the corresponding date in Gregorian calendar in %td 
format) in a variable named `Greg_date'. The following command does the job:

> sol2greg date, gen(Greg_date)


** Note 1: 
Solar Hijri date inputs must be provided in a string with the following format:
"year/month/day", e.g., "1390/6/1". 
However, instead of "/", your entry may contain any of these characters:
"/", "-", "+", ":",  "--", " "
For instance, "1390-6-1" and "1390:6+1" are both treated as "1390/6/1".

** Note 2:
The Solar Hijri 'year' must be a 4-digit number. Otherwise the command returns a 
syntax error. 
For example, for input "90/6/1" this command returns a syntax error.


*******************************************************************************
To test the "sol2greg" command follow these steps:
1. Move "sol2greg.ado" to your personal adopath directory (or you may use 
	"main.do" to specify your personal settings).
2. Change the global variable ${root} to your "sol2greg" folder directory.
3. Run "test_sol2greg.do".


Any questions, comments, or feedbacks are welcomed!
Contact: shahidi.peyman96@gmail.com
