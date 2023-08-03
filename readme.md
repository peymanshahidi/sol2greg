# `sol2greg`: Solar Hijri to Gregorian Calendar Conversion in Stata
#### Developed by Peyman Shahidi
#### Last updated on 3 August 2023 (12 Mordad 1402)


*******************************************************************************
## Description
The `sol2greg` command takes Solar Hijri date variable(s) as input and generates the corresponding Gregorian dates as output(s). `sol2greg` supports multiple variable formats (string, numeric, datetime) in both its inputs and outputs.


*******************************************************************************
## Features
`sol2greg` accommodates three types of Gregorian date inputs:

&nbsp; 1. A single string variable in `"year/month/day"` format (e.g., `"1390/06/01"`) where the command is able to flexibly handle `/`, `-`, `+`, `:`,  `--`, and <code>&nbsp;</code> (white space) as delimiters.

&nbsp; 2. A single variable in one of Stata datetime formats `%t*` (e.g., `01sha1390` with underlying value 18862). This is typically the output of [`greg2sol`](https://github.com/peymanshahidi/greg2sol) command.

&nbsp; 3. Three separate variables in year, month, day order. In this case each input variable can be in either string or numeric format.

<br>

`sol2greg` can generate up to three types of Solar Hijri date outputs:

&nbsp; 1. A single variable in `"year/month/day"` string format (e.g., `"2011/08/23"`).

&nbsp; 2. A single variable in Stata datetime format `%t*` (e.g., `23aug2011` with underlying value 18862).

&nbsp; 3. Three separate variables, one for each of year, month, day values, all in numeric format.


*******************************************************************************
## Examples
1. Suppose the Solar Hijri date value `1390/06/01` is stored in variable `dateSolar` (either in string or in Stata datetime format) and one wants to obtain the corresponding Gregorian calendar date `2011/08/23` under a new variable called `dateGregorian` in Stata `%td` format. The following command does this conversion:
```
sol2greg dateSolar, datetime(dateGregorian)
```
2. Suppose the Solar Hijri date value `1390/06/01` is stored in three variables `yearSolar` (1390), `monthSolar` (6), `daySolar` (1), and the corresponding Gregorian date `2011/08/23` is to be returned under a single output called `dateGregorian` in string format. The following command does this conversion:
```
sol2greg yearSolar monthSolar daySolar, string(dateGregorian)
```
For further examples and more detailed description of use cases refer to test materials or read the accompanying help file of the command.


*******************************************************************************
## Installation
In order to install `sol2greg`, run the following command in Stata:
```
net install sol2greg, from(https://raw.githubusercontent.com/peymanshahidi/sol2greg/master)
```

After installation, a comprehensive help file containing detailed description of `sol2greg` features along with examples is accessible by typing:
```
help sol2greg
```
Reading the help file before using the command is strongly recommended.


*******************************************************************************
## Test Materials
The file `sol2greg_test.do` in the current repository gives three examples to illustrate different use cases of `sol2greg` in Solar Hijri to Gregorian conversion. To test the command follow these steps:

&nbsp; 1. Download `sol2greg_test.do` from the current repository.

&nbsp; 2. Run the script!

The script comprises two sections. The first installs `sol2greg` and copies a test dataset into your current working direcotry. The second contains three test examples.


*******************************************************************************
## Citation
If you use `sol2greg` in your work, please cite it as below:
```
Shahidi, Peyman, 2023, "Solar Hijri to Gregorian Calendar Conversion in Stata," GitHub repository, https://github.com/peymanshahidi/sol2greg.
```
The citation information can be found in the `CITATION.bib` file.


*******************************************************************************
## Acknowledgements
Thanks are due to Hosein Joshaghani, who encouraged me to develop this command, and `d-learn.ir`, whose [historical IRR to USD exchange rate dataset](https://d-learn.ir/p/usd-price/) is used in the test materials.


*******************************************************************************
## Contact
For questions, comments, or feedbacks please contact shahidi.peyman96@gmail.com.

