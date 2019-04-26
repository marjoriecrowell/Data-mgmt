* THA4 
* I have merged 3 datasets in python and will bring in the dataset here to analyze it

* Bringing in merged dataset from python
import delimited using "/Users/marjoriecrowell/Documents/Data management/Data management assignments/THA4/merged_dataset/abortion_restrictions.csv"

* Some cleaning from when it exported as a csv:
	* Looking at data
	browse
	
	* I want to drop the aggregate US row
	drop if state == "United States"
	
	* I want to drop the v1 variable
	drop v1

* Preparing for analysis: I need to create dummy variables for the ones I'm looking at
	* Creating a dummy variable for waiting periods
	gen waiting_yn = .
	replace waiting_yn = 1 if waitingperiod=="Yes"
	replace waiting_yn = 0 if waitingperiod=="No"
	* A few states have enjoined policies - I'll exclude those
	replace waiting_yn = 0 if waitingperiod=="Enjoined; policy not in effect"
	replace waiting_yn = 0 if waitingperiod=="Policy temporary enjoined; policy not in effect"

	* Creating a dummy variable for required ultrasound
	gen ultrasound_yn = .
	replace ultrasound_yn = 1 if ultrasoundrequired=="Yes"
	replace ultrasound_yn = 0 if ultrasoundrequired=="No"

* Now I can do the regression
regress abortion_rate_2014 waiting_yn ultrasound_yn
