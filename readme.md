# Stata Command for Solar Hijri to Gregorian Calendar Conversion
#### Developed by Peyman Shahidi
#### Last updated on 28 Tir 1402 - 19 July 2023

*******************************************************************************
## Command Description
The `sol2greg` command takes Solar Hijri date variable(s) as input and produces corresponding Gregorian calendar dates in Stata `%td` datetime format under a user-specified variable name.

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

&nbsp; 1. A single string variable in the `year/month/day` format (e.g., `1390/6/1`), where the command can flexibly handle `/`, `-`, `+`, `:`,  `--`, <code>&nbsp;</code> (white space) as delimiters. For instance, `1390-6-1` and `1390:6+1` are both treated similar to `1390/6/1`.

&nbsp; 2. Three separate variables in (`year`, `month`, `day`) order. In this case each input variable can be in either string or numeric format.

<br>

### Note 2:
The Solar Hijri `year` must be a 4-digit number. This is intentional so that the user, rather than the program, makes the distinction between 2-digit values corresponding to abbreviation of 13-- or 14-- Solar Hijri years (i.e., Solar Hijri year value `05`, for example, can correspond to either 1305 or 1405 in conventional use cases). If all inputs are given in a 2-digit format (e.g., `90/6/1` in the single-input use case of the program) the `sol2greg` command returns a syntax error. However, if some observations contain 4-digit year values while others contain 2-digit year values (e.g., one observation in the form of `90/6/1` and another in the form of `1391/6/1`) the command **DOES NOT** return a syntax error. In the latter case, it is assumed that the user has intentionally provided entries in such manner.


*******************************************************************************
## Test Materials 
To test the `sol2greg` command take the following steps:

&nbsp;1. Download (or clone) the project.

&nbsp;2. Define global macro `root` to be the path of `sol2greg` folder on your machine in the `sol2greg_test.do` script.

&nbsp;3. Run the `sol2greg_test.do` script, which contains one example from each use case of the command (single-variable input and three-variables input).

P.S.: if you do not wish to change the adopath directory on your machine, you should put the `sol2greg.ado` file in your personal adopath directory and comment out `line 19` in the `sol2greg_test.do` script.


*******************************************************************************
## Acknowledgements
Thanks are due to Hosein Joshaghani, who encouraged me to develop this command, and `d-learn.ir`, whose [historical IRR to USD exchange rate dataset](https://d-learn.ir/p/usd-price/) I have used for the test cases.


*******************************************************************************
## Contact
For questions, comments, or feedbacks please contact me at: shahidi.peyman96@gmail.com