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
			replace waiting_yn = 0 if waiting_period_str == "Policy temporarily enjoined; policy not in effect"

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
		
		* Creating dummy variable for state expressing intent to limit abortion to the earliest extent possible
		gen want_to_limit_yn = .
		replace want_to_limit_yn = 1 if want_to_limit_str == "Yes"
		replace want_to_limit_yn = 0 if want_to_limit_str == "No"
		
		gen restrictive_policy_yn = .
		replace restrictive_policy_yn = 1 if want_to_limit_yn==1 | pre_roe_ban_yn ==1
		replace restrictive_policy_yn = 0 if want_to_limit_yn==0 & pre_roe_ban_yn==0
		
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
		gen partial_birth_ban_yn = .
		replace partial_birth_ban_yn = 1 if partial_birth_ban_str == "Yes"
		replace partial_birth_ban_yn = 0 if partial_birth_ban_str == "No"
		replace partial_birth_ban_yn = 0 if partial_birth_ban_str == "Enjoined or not Enforced"
		
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
******************** COMPOSITE SCORE **********************
***********************************************************
gen composite_regulations = parental_consent_yn + partial_birth_ban_yn + hyde_yn ///
+ restrictive_policy_yn + asc_requirement_yn + any_gest_limit_yn + ultrasound_yn + waiting_yn


******* PROVIDER REGS ONLY
gen composite_providers = partial_birth_ban_yn + asc_requirement_yn

******** PATIENT REGS ONLY
gen composite_patients = parental_consent_yn + hyde_yn ///
+ any_gest_limit_yn + ultrasound_yn + waiting_yn

******** WITH PROTECTIVE EFFECTS
gen composite_regulations_protective = parental_consent_yn + partial_birth_ban_yn + hyde_yn ///
+ restrictive_policy_yn + asc_requirement_yn + any_gest_limit_yn + ultrasound_yn + ///
waiting_yn - more_than_hyde_yn - protects_right_yn

***********************************************************	
******************** REGRESSION ***************************
***********************************************************

**** Model 1: 
* relationship between the number of CPCs & abortion providers in a state
* controlling for state population
regress number_cpcs number_providers state_pop
* Adjusted R2 = 0.8416
* Root MSE = 18.111
* all variables p=0.000

**** Model 2:
* number of crisis pregnancy centers and providers in a state
* controlling for both state population and voting behavior
regress number_cpcs number_providers state_pop republican2016_yn
* Adjusted R2 = 0.8443
* Root MSE = 17.959
* all variables p<0.005 except republican2016_yn

**** Model 3:
* number of crisis pregnancy centers and providers in a state
* controlling for state population, uninsured rate, voting behavior
regress number_cpcs number_providers state_pop uninsured_2015 republican2016_yn
* Adjusted R2 = 0.8544
* Root MSE = 17.364
* all variables p<.005

**** Model 4:
* number of crisis pregnancy centers and providers in a state AND all regulations
* controlling for state population, uninsured rate, voting behavior
regress number_cpcs number_providers parental_consent_yn partial_birth_ban_yn ///
hyde_yn restrictive_policy_yn asc_requirement_yn any_gest_limit_yn ultrasound_yn ///
waiting_yn state_pop uninsured_2015 republican2016_yn
* Adjusted R2 = 0.8334
* Root MSE = 18.577
* number providers, state_pop only significant variables

**** Model 5
* number of crisis pregnancy centers and providers in a state AND composite score
* controlling for state population, uninsured rate, voting behavior
regress number_cpcs number_providers composite_regulations state_pop uninsured_2015 republican2016_yn
* Adjusted R2 = 0.8514
* Root MSE = 17.54
* number providers, state pop, uninsured 2015 only sig variables

** Model 6
* number of crisis pregnancy centers and providers in a state AND composite score ON PROVIDERS
* controlling for state population, uninsured rate, voting behavior
regress number_cpcs number_providers composite_providers state_pop uninsured_2015 republican2016_yn
* Adjusted R2 = 0.8512
* Root MSE = 17.553
* number providers, state pop, repub 2016 significant, uninsured=.05 

** Model 7
* number of crisis pregnancy centers and providers in a state AND composite score ON PATIENTS
* controlling for state population, uninsured rate, voting behavior
regress number_cpcs number_providers composite_patients state_pop uninsured_2015 republican2016_yn
* adjusted R2 = 0.8514
* Root MSE = 17.545
* number providers, state pop uninsured 2015 sig

** Model 8
* number of crisis pregnancy centers and providers in a state AND composite score WITH PROTECTION
* controlling for state population, uninsured rate, voting behavior
regress number_cpcs number_providers composite_regulations_protective state_pop ///
uninsured_2015 republican2016_yn
* Adj R2 = 0.8513
* root MSE = 17.547
* number providers, state pop, uninsured significant 

