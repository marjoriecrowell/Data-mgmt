* Cleaning CPCs file in Stata
* Created April 17, 2019 by Marjorie Crowell
* Last modified April 17, 2019

/* I couldn't figure out how to split up the string of "City, State, Zip Code" 
in Python, so I'm reading it into Stata to split up. I'll rename the variables 
for something more useful and will also save it as a stata file since my final
analysis will be in Stata. */

import delimited using "/Users/marjoriecrowell/Desktop/for Stata/cpcs.csv"

* Importing this from my python notebook dropped any variable names, so I'll rename them
gen idno = v1
drop if v1==.
drop v1


* Generating variable name for name of CPC
gen name = v2
drop v2

* I don't need the street address - will drop
drop v3

* I have to do a lot of work on city, state, zip
gen citystatezip = v4
drop v4

* I need to split this variable up - 
split citystatezip, parse(,)
* There is one row where state is followed by a comma, so that becomes three new vars
drop citystatezip3
rename citystatezip1 city
rename citystatezip2 statezip

* I need to split state and zip
split statezip
rename statezip1 state
rename statezip2 zipcode
drop statezip
drop citystatezip

save "/Users/marjoriecrowell/Documents/Data management/Data management assignments/Final project/Working data/cpcs.dta"

