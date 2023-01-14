# Instructions for "sol2greg" Stata command 
### Author: Peyman Shahidi
#### Last update: Jan 14, 2023


This command takes input variables in Solar Hijri calendar date format and returns
the corresponding Gregorian calendar date in Stata datetime format.

<br>

#### Example: 
Suppose variable `date` contains date entries under the Solar Hijri calendar format (e.g., `1390/6/1`). The following command generates a new variable `Greg_date` under the corresponding Gregorian calendar date format (e.g., `23aug2013` for `1390/6/1`):

```
sol2greg date, gen(Greg_date)
```

*******************************************************************************
#### Test Materials 
To run the test materials for `sol2greg` take the following steps:
1. Move `sol2greg.ado` to your personal adopath directory (or use `main.do` to specify your personal settings).
2. Change the global variable `root` to your `sol2greg` folder directory.
3. Run `test_sol2greg.do`.


*******************************************************************************
#### Note 1: 
Solar Hijri input variable must be in the following string format:
`year/month/day`, e.g., `1390/6/1`. Though, instead of the seperator `/`, the entry may contain any of the following characters: `/`, `-`, `+`, `:`,  `--`, or empty space (` `)

Example: `1390-6-1` and `1390:6+1` are both treated similar to `1390/6/1`.

<br>

#### Note 2:
The `year` value in the `year/month/day` input format must be a 4-digit number. Otherwise the command returns a syntax error. 

Example: for input `90/6/1` the command returns a syntax error.


*******************************************************************************

For questions, comments, or feedbacks please contact me at: shahidi.peyman96@gmail.com 
