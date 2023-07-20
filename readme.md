# `sol2greg`: Solar Hijri to Gregorian Calendar Conversion in Stata
#### Developed by Peyman Shahidi
#### Last updated on 29 Tir 1402 (20 July 2023)

*******************************************************************************
## Command Description
The `sol2greg` command takes Solar Hijri date variable(s) as input and produces corresponding Gregorian calendar dates in Stata `%td` datetime format under a user-specified variable name.

<br>

### Examples:
1. Suppose Solar Hijri date value `1390/6/1` is stored in variable `dateSolar` and one wants to obtain the corresponding Gregorian calendar date `23aug2011` under a new variable called `dateGreg` in Stata `%td` datetime format. The following command does this conversion:
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

&nbsp; 1. A single string variable in `"year/month/day"` format (e.g., `"1390/6/1"`), where the command can flexibly handle `/`, `-`, `+`, `:`,  `--`, and <code>&nbsp;</code> (white space) as delimiters. For instance, `"1390-6-1"` and `"1390:6+1"` are both treated similar to `"1390/6/1"`.

&nbsp; 2. Three separate variables in `year`, `month`, `day` order. In this case each input variable can be in either string or numeric format.

<br>

### Note 2:
The Solar Hijri `year` value must be a 4-digit number. This is intentional so that the user, rather than the program, makes the distinction between 2-digit abbreviations of 13-- or 14-- Solar Hijri years (i.e., Solar Hijri abbreviation `05`, for example, can correspond to either 1305 or 1405 in conventional use cases). If all inputs are given in a 2-digit format (e.g., `"90/6/1"` in the single-input use case of the program) the `sol2greg` command returns a syntax error. However, if some observations contain 4-digit year values while others contain 2-digit year values (e.g., one observation in the form of `"90/6/1"` and another in the form of `"1391/6/1"`) the command **DOES NOT** return a syntax error. In the latter case, it is assumed that the user has intentionally provided entries in such manner.


*******************************************************************************
## Test Materials 
The `sol2greg_test.do` file contains one example for each use case of the command (single- or three-variable input). To run the `sol2greg_test.do` script take the following steps:

&nbsp;1. Download the `sol2greg` project files.

&nbsp;2. Define global macro `root` in `line 11` of the `sol2greg_test.do` script to be the path of `sol2greg` folder on your machine (the path of files downloaded in previous step).

&nbsp;3. Run the script.

P.S.: The `sol2greg_test.do` script changes the adopath direcotry in your machine to the path of `sol2greg` folder. If you do not wish to have this change made, you can put the `sol2greg.ado` file in your personal adopath directory and comment out `line 19` in the script.


*******************************************************************************
## Citation
If you use this command, please cite it as below:
```
Shahidi, Peyman, Solar Hijri to Gregorian Calendar Conversion in Stata, (2023), GitHub repository, https://github.com/peymanshahidi/sol2greg
```


*******************************************************************************
## Acknowledgements
Thanks are due to Hosein Joshaghani, who encouraged me to develop this command, and `d-learn.ir`, whose [historical IRR to USD exchange rate dataset](https://d-learn.ir/p/usd-price/) is used for the test materials.


*******************************************************************************
## Contact
For questions, comments, or feedbacks please contact me via shahidi.peyman96@gmail.com