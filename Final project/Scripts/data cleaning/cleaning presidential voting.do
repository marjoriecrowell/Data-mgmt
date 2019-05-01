* Cleaning presidential voting dataset
import delimited using "/Users/marjoriecrowell/Documents/Data management/Data management assignments/Final project/Raw Data/voting behavior/1976-2016-president.csv"

* I only want to focus on 2012 and 2016 election
drop if year<=2008

* Drop 3rd party candidates
* FOR MINNESOTA IN 2012, Barack Obama is not listed as just "Democrat"
drop if party != "democrat" & party != "republican" & party !="democratic-farmer-labor"

* Drop the variables about state identifiers - I only need the state name
drop state_*

* Replace the name for Minnesota's Democratic candidate
replace party="democrat" if party=="democratic-farmer-labor"

* Drop write-ins for 2 main party candidates
drop if writein == "TRUE"

foreach 

gen republican2012 = .
foreach state in "Alabama" "Alaska" "Arizona" "Arkansas" "California" ///
"Colorado" "Connecticut" "Delaware" "District of Columbia" "Florida" "Georgia" ///
 "Hawaii" "Idaho" "Illinois" "Indiana" "Iowa" "Kansas" "Kentucky" "Louisiana" ///
 "Maine" "Maryland" "Massachusetts" "Michigan" "Minnesota" "Mississippi" ///
 "Missouri" "Montana" "Nebraska" "Nevada" "New Hampshire" "New Jersey" ///
 "New Mexico" "New York" "North Carolina" "North Dakota" "Ohio" "Oklahoma" ///
 "Oregon" "Pennsylvania" "Rhode Island" "South Carolina" "South Dakota" ///
 "Tennessee" "Texas" "Utah" "Vermont" "Virginia" "Washington" "West Virginia" ///
 "Wisconsin" "Wyoming" {
 replace republican2012=1 if 
 

}
gen republican2016 = .

