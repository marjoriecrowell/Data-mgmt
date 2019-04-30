* Cleaning CPCs file in Stata
* Created April 29, 2019 by Marjorie Crowell
* Last modified April 29, 2019

/* I couldn't figure out how to split up the string of "City, State, Zip Code" 
in Python, so I'm reading it into Stata to split up. I'll rename the variables 
for something more useful and will also save it as a stata file since my final
analysis will be in Stata. */

import delimited using "/Users/marjoriecrowell/Desktop/for Stata/cpcs_abortion.csv"

* I want to drop the v1 id number variable
drop v1

* Renaming CPC variable
rename cpcname numbercpcs

* I don't need both state_id variables
drop state_id_y
rename state_id_x state_id

* I need to rename a lot of variables 
*MAYBE JUST DONT TAKE THIS ONE IN PYTHON
drop gestationallimit


* Now I need to recode for dummy variables
gen any_gest_limit=.
replace any_gest_limit = 0 if stateprohibitssomeabortionsafter=="No"
replace any_gest_limit = 1 if stateprohibitssomeabortionsafter=="Yes"
replace any_gest_limit=. if stateprohibitssomeabortionsafter=="43 Yes"

gen later_abortion=.
replace later_abortion=3 if whenislaterabortionpermitted=="Life"
replace later_abortion=1 if whenislaterabortionpermitted=="Life and health"
replace later_abortion=2 if whenislaterabortionpermitted=="Life and physical health"
* 9 are missing

gen ultrasound=.
replace ultrasound=0 if ultrasound_required=="No"
replace ultrasound=1 if ultrasound_required=="Yes"
replace ultrasound=. if ultrasound_required=="26 Yes"

* Regressions
regress numbercpcs numberproviders numberabortions any_gest_limit ultrasound
* Number of providers and ultrasound are both significant


save "/Users/marjoriecrowell/Documents/Data management/Data management assignments/Final project/Working data/cpcs.dta"

