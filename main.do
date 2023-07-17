********************************************************************************
** Description:		   Initiate test run for "sol2greg" command
** By:  						 Peyman Shahidi
** File Name:						 main.do
** Version Date:	  	    26 Tir 1402 - 17 July 2023
********************************************************************************

** set working direcotry to the "sol2greg" folder path on your machine
global root "path_to/sol2greg"
global data "${root}"

cd "${root}"
adopath + "${root}" 


** run the "sol2greg" command test script
do sol2greg_test
