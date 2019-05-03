* Cleaning presidential voting dataset
import delimited using "/Users/marjoriecrowell/Documents/Data management/Data management assignments/Final project/Working data/merged_cpcs_ab_health_demographic.csv"

* The merges brought in lots of different state variables so I want to drop some
drop state_id_x state_id_y state_y
rename state_x state_fullname

* Drop the v1 variable Python created
drop v1

drop v49

rename v50 pres2012result
rename v51 pres2016result

drop if state == ""

drop if state == "United States"

* Rename CPC variable
rename cpcname numbercpcs

* I need to recode my dummy variables for analysis
	* Creating a dummy variable for waiting periods
		gen waiting_yn = .
		replace waiting_yn = 1 if waitingperiod=="Yes"
		replace waiting_yn = 0 if waitingperiod=="No"
	
		* A few states have enjoined policies - I'll exclude those
		replace waiting_yn = 0 if waitingperiod=="Enjoined; policy not in effect"
		replace waiting_yn = 0 if waitingperiod=="Policy temporary enjoined; policy not in effect"

	* Creating a dummy variable for required ultrasound
		gen ultrasound_yn = .
		replace ultrasound_yn = 1 if ultrasound_required=="Yes"
		replace ultrasound_yn = 0 if ultrasound_required=="No"
	
	* Creating a dummy variable for any gestational limit
		gen anygestlimit = .
		replace anygestlimit = 0 if stateprohibitssomeabortionsafter=="No"
		replace anygestlimit = 1 if stateprohibitssomeabortionsafter=="Yes"
	
	* Creating a dummy variable for state voting republican in 2012, 2016
		gen republican2012=.
		replace republican2012 = 1 if pres2012result=="R"
		replace republican2012 = 0 if pres2012result=="D"
	
		gen republican2016=.
		replace republican2016 = 1 if pres2016result == "R"
		replace republican2016 = 0 if pres2016result == "D"
		
	* Creating a dummy variable for ASC requirement
		gen asc_yn = .
		replace asc_yn = 1 if ascrequirement=="Yes"
		replace asc_yn = 0 if ascrequirement=="No"
		replace asc_yn = 0 if ascrequirement=="Yes; Policy not in effect"
		
	* Creating a dummy variable for pre-Roe ban still law
		gen preRoeban = .
		replace preRoeban = 1 if preroebanstilllaw == "Yes"
		replace preRoeban = 0 if preroebanstilllaw == "No"
		
	* Creating a dummy variable for law protecting right to abortion
		gen lawprotectsright = .
		replace lawprotectsright = 1 if lawprotectsrighttoabortion == "Yes"
		replace lawprotectsright = 0 if lawprotectsrighttoabortion == "No"
		
	* Creating a dummy variable for Medicaid expansion
		gen medicaid_yn = .
		replace medicaid_yn = 1 if medicaidexpanded == "Adopted"
		replace medicaid_yn = 0 if medicaidexpanded == "Not Adopted"

***********************************************************	
******************** REGRESSION ***************************
***********************************************************

* anygestlimit not significant even on its own
* Neither is asc
* Neither is medicaid expansion but that is a control

regress numbercpcs medicaid_yn uninsuredratechange20102015 preRoeban republican2016 republican2012 waiting_yn numberabortions numberproviders
