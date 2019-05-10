* Cleaning presidential voting dataset
import delimited using "/Users/marjoriecrowell/Documents/Data management/Data management assignments/Final project/Data/Final dataset/merged_cpcs_ab_health_demographic.csv"

* Drop the v1 variable Python created
drop v1

* I need to recode my dummy variables for analysis
	***** Abortion regulations
		* Creating a dummy variable for waiting periods
		gen waiting_yn = .
		replace waiting_yn = 1 if waiting_period_str=="Yes"
		replace waiting_yn = 0 if waiting_period_str=="No"
	
			* A few states have enjoined policies - I'll exclude those
			replace waiting_yn = 0 if waiting_period_str=="Enjoined; policy not in effect"
			replace waiting_yn = 0 if waiting_period_str=="Policy temporary enjoined; policy not in effect"

		* Creating a dummy variable for required ultrasound
		gen ultrasound_yn = .
		replace ultrasound_yn = 1 if ultrasound_required_str=="Yes"
		replace ultrasound_yn = 0 if ultrasound_required_str=="No"
	
		* Creating a dummy variable for any gestational limit
		gen any_gest_limit_yn = .
		replace any_gest_limit_yn = 0 if any_gest_limit_str=="No"
		replace any_gest_limit_yn = 1 if any_gest_limit_str=="Yes"
			
		* Creating a dummy variable for ASC requirement
		gen asc_requirement_yn = .
		replace asc_requirement_yn = 1 if asc_requirement_str=="Yes"
		replace asc_requirement_yn = 0 if asc_requirement_str=="No"
		replace asc_requirement_yn = 0 if asc_requirement_str=="Yes; Policy not in effect"
		
		* Creating a dummy variable for pre-Roe ban still law
		gen pre_roe_ban_yn = .
		replace pre_roe_ban_yn = 1 if pre_roe_ban_str == "Yes"
		replace pre_roe_ban_yn = 0 if pre_roe_ban_str == "No"
		
		* Creating a dummy variable for law protecting right to abortion
		gen protects_right_yn = .
		replace protects_right_yn = 1 if protects_right_str == "Yes"
		replace protects_right_yn = 0 if protects_right_str == "No"
		
		* Creating a dummy variable for Medicaid coverage of abortions
		gen hyde_yn = .
		replace hyde_yn = 1 if hyde_str == "Yes"
		replace hyde_yn = 0 if hyde_str == "No"
		
		gen more_than_hyde_yn = .
		replace more_than_hyde_yn = 1 if more_than_hyde_str == "Yes"
		replace more_than_hyde_yn = 0 if more_than_hyde_str == "No"
		
		* Creating a dummy variable for 'partial-birth' ban
		gen partial_birth_yn = .
		replace partial_birth_yn = 1 if partial_birth_str == "Yes"
		replace partial_birth_yn = 0 if partial_birth_str == "No"
		replace partial_birth_yn = 0 if partial_birth_str == "Enjoined or not Enforced"
		
		* Creating a dummy variable for parental consent
		gen parental_consent_yn = .
		replace parental_consent_yn = 1 if parental_consent_str == "Consent enforced"
		replace parental_consent_yn = 1 if parental_consent_str == "Notification and consent enforced"
		replace parental_consent_yn = 1 if parental_consent_str == "Notification enforced"
		replace parental_consent_yn = 0 if parental_consent_str == "No Law" 
		replace parental_consent_yn = 0 if parental_consent_str == "Consent enjoined or not enforced"
		replace parental_consent_yn = 0 if parental_consent_str == "Notification enjoined or not enforced"
		replace parental_consent_yn = 0 if parental_consent_str == "Consent and notification temporarily enjoined"
		
	***** Political and demographic vars
		* Creating a dummy variable for state voting republican in 2012, 2016
		gen republican2012_yn=.
		replace republican2012_yn = 1 if vote2012_str=="R"
		replace republican2012_yn = 0 if vote2012_str=="D"
	
		gen republican2016_yn=.
		replace republican2016_yn = 1 if vote2016_str == "R"
		replace republican2016_yn = 0 if vote2016_str == "D"
	
	***** Health coverage
	* Creating a dummy variable for Medicaid expansion
		gen medicaid_expanded_yn = .
		replace medicaid_expanded_yn = 1 if medicaid_expanded_str == "Adopted"
		replace medicaid_expanded_yn = 0 if medicaid_expanded_str == "Not Adopted"


		
***********************************************************	
******************** REGRESSION ***************************
***********************************************************
