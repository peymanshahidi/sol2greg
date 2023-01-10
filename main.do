********************************************************************************
* Title:		main.do
* Description:	Initiate test run for "sol2greg" command.
* By:  			Peyman Shahidi
* Date:			Oct 10, 2020
				
********************************************************************************

* sol2greg folder path
global root "/Users/peymansh/Dropbox/Personal/StataPackages/sol2greg"
//global root "path to/sol2greg"
global data "${root}"

cd "${root}"
adopath + "${root}" 

*===============================================================================
do test_sol2greg
