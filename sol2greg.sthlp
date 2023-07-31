{smcl}
{* *! version 1.0  31jul2023}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] datetime display formats" "help datetime_display_formats"}{...}
{vieweralsosee "[F] format" "help format"}{...}
{vieweralsosee "[G] greg2sol" "help greg2sol"}{...}
{viewerjumpto "Syntax" "sol2greg##syntax"}{...}
{viewerjumpto "Description" "sol2greg##description"}{...}
{viewerjumpto "Options" "sol2greg##options"}{...}
{viewerjumpto "Installation" "sol2greg##installation"}{...}
{viewerjumpto "Examples" "sol2greg##examples"}{...}
{viewerjumpto "Citation" "sol2greg##citation"}{...}
{viewerjumpto "Contact" "sol2greg##contact"}{...}
{title:Title}

{phang}
{manlink S sol2greg} {hline 2} Solar Hijri to Gregorian Calendar Conversion in Stata


{marker syntax}{...}
{title:Syntax}

{pstd}
      {cmd:sol2greg} 	{{varname} | {varlist}}
			{ifin}
	       		{cmd:,} {{opth sep:arate(namelist)} | {opth st:ring(name)} | {opth d:atetime(name)}}
			[{opth f:ormat(str)}]


{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Output}
{p2coldent :* {opth sep:arate(namelist)}}generate three separate variables for year, month, day values{p_end}
{p2coldent :* {opth st:ring(name)}}generate a string variable in "{bf:year/month/day}" format{p_end}
{p2coldent :* {opth d:atetime(name)}}generate a variable in {bf:%td} datetime format{p_end}

{syntab:Datetime Format}
{p2coldent :{opth f:ormat(str)}}specify datetime display format for output of {opth d:atetime(name)} option. See {manhelp datetime_display_formats D:datetime display formats}.{p_end}
{synoptline}
{pstd}* Any number of output options can be specified concurrently, but specifying at least one is required.


{marker description}{...}
{title:Description}

{pstd}
{cmd:sol2greg} takes Solar Hijri dates in {varlist} or {varname} and generates
corresponding Gregorian dates under new variable(s). {cmd:sol2greg} accommodates three different types of input:

{phang}1. A string variable in "{bf:year/month/day}" format (e.g., "{it:1390/06/01}") where the command can handle "/", "-", "+", ":",  "--", " " (white space) as delimiters.{p_end}
{phang}2. A Stata datetime variable in {bf:%t*} format (e.g., {it:01sha1390} in {bf:%td} format with underlying value 18862). This is typically the output of the {cmd:greg2sol} command which generates Solar Hijri-labeled date variables in datetime format (see {manhelp greg2sol G:greg2sol}).{p_end}
{phang}3. Three separate variables in year, month, day order. In this case each input variable can be in either string or numeric format.{p_end}

{phang} Note: The Solar Hijri {it:year} value must be a 4-digit number.
This is intentional so that the user, rather than the program, makes the distinction between 2-digit abbreviations of 13-- or 14-- Solar Hijri years
(e.g., 05 can correspond to either 1305 or 1405 in conventional use cases). If all inputs are given in a 2-digit format
(e.g., {it:90/06/01} in the single-input use case of the program) {cmd:sol2greg} returns an error.
However, if some observations contain 4-digit year values while others contain 2-digit year values
(e.g., one observation in the form of {it:90/06/01} and another in the form of {it:1391/06/01}) the command {it:does not} return an error.
In the latter case, it is assumed that user has intentionally provided entries in such manner.{p_end}


{marker options}{...}
{title:Options}

{dlgtab:Output}

{phang}
{opth sep:arate(namelist)} creates three separate year, month, day variables associated with Gregorian date values. Names of three output variables are provided via {it:namelist} in year, month, day order.

{phang}
{opth st:ring(name)} creates a single string variable associated with Gregorian dates in "{bf:year/month/day}" format. Name of output variable is provided via {it:name}.

{phang}
{opth d:atetime(name)} creates a single variable in {bf:%td} datetime format. Name of output variable is provided via {it:name}. Datetime format of the variable can be changed through the {opth f:ormat(str)} option. See [][][][][][][][] Datetime

{dlgtab:Datetime Format}

{phang}
{opth f:ormat(str)} specifies datetime display format of output generated through the {opth d:atetime(name)} option. See {manhelp datetime_display_formats D:datetime display formats} for available options. 
The functionality of {opth f:ormat(str)} is similar to the Stata's own {cmd:format} command (see {manhelp format F:format}).


{marker installation}{...}
{title:Installation}

{pstd}In order to install {cmd:sol2greg}, run the following command:{p_end}

{phang2}{cmd:. net install sol2greg, from(https://raw.githubusercontent.com/peymanshahidi/sol2greg/master)}{p_end}

{pstd}An ancillary IRR to USD historical exchange rate dataset is shipped during the installation process for test purposes. This dataset is deleted after the current Stata session is terminated.{p_end}


{marker examples}{...}
{title:Examples}

{pstd}String input / Multiple outputs (separated, string, and datetime){p_end}
    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse IRR_USD_histExRate, clear}{p_end}

{pstd}Convert Solar Hijri to Gregorian{p_end}
{phang2}{cmd:. sol2greg dateSolarHijri, separate(yearGregorian monthGregorian dayGregorian) string(gregDate_str) datetime(gregDate_datetime) format(%tC)}{p_end}


{pstd}Datetime input / Separated outputs{p_end}
    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse IRR_USD_histExRate, clear}{p_end}

{pstd}Generate a Solar Hijri variable in datetime format{p_end}
{phang2}{cmd:. greg2sol dateGregorian, datetime(solarDate_datetime)}{p_end}

{pstd}Convert Solar Hijri to Gregorian{p_end}
{phang2}{cmd:. sol2greg solarDate_datetime, separate(yearGregorian monthGregorian dayGregorian)}{p_end}


{pstd}Separated inputs / String output{p_end}
    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse IRR_USD_histExRate, clear}{p_end}

{pstd}Generate separate Solar Hijri date variables{p_end}
{phang2}{cmd: split dateSolarHijri, p("/") destring}{p_end}
{phang2}{cmd:. rename dateSolarHijri1 solarYear}{p_end}
{phang2}{cmd:. rename dateSolarHijri2 solarMonth}{p_end}
{phang2}{cmd:. rename dateSolarHijri3 solarDay}{p_end}

{pstd}Convert Solar Hijri to Gregorian{p_end}
{phang2}{cmd:. sol2greg solarYear solarMonth solarDay, st(gregDate_str)}{p_end}


{marker citation}{...}
{title:Citation}

{pstd}If you use this command, please cite it as below:{p_end}

{phang}
Shahidi, Peyman, 2023, {browse "https://github.com/peymanshahidi/sol2greg":"{it:Solar Hijri to Gregorian Calendar Conversion in Stata},"} GitHub repository, https://github.com/peymanshahidi/sol2greg.


{marker acknowledgements}{...}
{title:Acknowledgements}

{pstd}Thanks are due to Hosein Joshaghani, who encouraged me to develop this command,
and {bf:d-learn.ir}, whose {browse "https://d-learn.ir/p/usd-price/":historical IRR to USD exchange rate dataset} is used in the test materials.{p_end}


{marker contact}{...}
{title:Contact}

{pstd}For questions, comments, or feedbacks please contact {browse "mailto:shahidi.peyman96@gmail.com":shahidi.peyman96@gmail.com}.{p_end}

