# Stata Command for Solar Hijri to Gregorian Calendar Conversion
#### Developed by Peyman Shahidi
#### Last updated on 28 Tir 1402 - 19 July 2023

*******************************************************************************
## Command Description
The "sol2greg" command takes Solar Hijri date variable(s) as input and produces corresponding Gregorian calendar dates in Stata `%td` datetime format under a user-specified variable name.

<br>

### Examples:
1. Suppose Solar Hijri date value `1390/6/1` is stored in variable `dateSolar` and one wants to obtain the corresponding Gregorian calendar date `23aug2013` under a new variable called `dateGreg` in Stata `%td` datetime format. The following command does this conversion:
```
sol2greg dateSolar, gen(dateGreg)
```
2. If the Solar Hijri input date value `1390/6/1` is stored in three separate variables `yearSolar` (1390), `monthSolar` (6), `daySolar` (1), and the output is to be returned under a variable called `dateGreg`, one can use the following command for conversion:
```
sol2greg yearSolar monthSolar daySolar, gen(dateGreg)
```
*******************************************************************************
## Notes

### Note 1: 
The `sol2greg` command can manage two types of inputs:

&nbsp; 1. A single string variable in the `year/month/day` format (e.g., `1390/6/1`), where the command is able to flexibly handle the following delimiters: `/`, `-`, `+`, `:`,  `--`, <code>&nbsp;</code> (white space). For instance, `1390-6-1` and `1390:6+1` are treated similar to `1390/6/1`.

&nbsp; 2. Three separate variables in the (`year`, `month`, `day`) order. In this case each input variable can be in either string or numeric format.

<br>

### Note 2:
The Solar Hijri `year` must be a 4-digit number. This is intentional so that the user, rather than the program, makes the distinction between 2-digit values corresponding to abbreviation of either 13-- or 14-- Solar Hijri years (e.g., Solar Hijri year value `05` can correspond to either 1305 or 1405 in conventional use cases). If all inputs are given in a 2-digit format (e.g., `90/6/1` in the single-input use case of the program) the `sol2greg` command returns a syntax error. However, if some observations contain 4-digit year values while others contain 2-digit year values (e.g., one observation in the form of `90/6/1` and another in the form of `1391/6/1`) the command DOES NOT return a syntax error. In the latter case, it is assumed that the user has intentionally provided entries in such manner.


*******************************************************************************
## Test Materials 
To test the `sol2greg` command take the following steps:

&nbsp;1. Move `sol2greg.ado` to your personal adopath directory (or use the `main.do` script to specify your personal settings).

&nbsp;2. Change the global variable `${root}` to your `sol2greg` folder directory.

&nbsp;3. Run `sol2greg_test.do`.


*******************************************************************************
## Acknowledgements
Thanks are due to Hosein Joshaghani, who encouraged me to develop this command, and `d-learn.ir`, whose historical IRR to USD exchange rate dataset I have used for the test cases.


*******************************************************************************
## Contact
For questions, comments, or feedbacks please contact me at: shahidi.peyman96@gmail.com