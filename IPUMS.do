* PPHA 31202 Advanced Statistics for Data Analysis 1, Fall 2021
* PSET4

*Grishma Bhattarai
*10/27/2021

clear 
capture log close
set more off
log using "C:\Users\grishmab\OneDrive - The University of Chicago\Coding\Stata\PSET4.log" , replace


*load data*
*names forces STATA to recognise first line in data as as variabe names 

use "C:\Users\grishmab\OneDrive - The University of Chicago\Coding\Stata\ppha312x2021.dta"
label data "Data is from IPUMS-USA  restricted to Memphis Metropolitan Area)"

*Data cleaning
* To check the data for missing values or data that doesn't make sense. We first look at the summary of 
* all the variables in the data. 

summarize

* We see that inctot,which is total income of the individual has some negative values.
* This doesn't make sense. So, we'll filter the data to only consider income greater 
* than or equal to zero 

keep if inctot >= 0

* Then we summarize the data again to check if the above change was incorporated

summarize

* Define a dummy variable indicating the respondent is Hispanic or not.
gen is_hispanic = 1
*check codebook to confirm that hispan==1,2,3,4 is hispanic
replace is_hispanic = 0 if (hispan==0) 

* Define a dummy variable indicating the respondent is African American or not. 
gen is_aframerican = 0
*check codebook to confirm that race==2 is African American
replace is_aframerican = 1 if (race==2) 



* Limit sample to white, non-Hispanic or African American non-Hispanichispanic residents
*check codebook to confirm that race==1 is White and race==2 is African American 
keep if (race == 1 & is_hispanic == 0) | (race == 2 & is_hispanic == 0)



*Limit the sample to those 25 to 59 years of age
keep if age >= 25 & age < = 59



*Define a binary variable indicating whether the respondent is female
gen is_female = 0
*check codebook to confirm that sex==2 is Female
replace is_female = 1 if (sex==2) 



*e. Create an education variable with five categories: Less than high school (including GED recipients), high school degree, some college (including associates degree), bachelor’s degree, and graduate degree

*check codebook to confirm that numeric values of each of the 19 categories in educd

gen edu_level = "Some College" if educd == 71 | educd == 81 | educd == 65

replace edu_level = "Less than High School" if educd == 61 | educd == 40 | educd == 50 | educd == 22 | educd == 23 | educd == 25 | educd == 26 |  educd == 30 |  educd == 2 | educd == 11 | educd == 64

replace edu_level = "Bachelor's Degree" if educd == 101

replace edu_level = "Graduate Degree" if educd == 116 |educd == 114 | educd == 115

replace edu_level = "High School Degree" if educd == 63


*Define a dummy variable for whether the respondent is employed
gen is_empld = 0
*check codebook to confirm that empstat==1 is Employed
replace is_empld = 1 if (empstat==1) 
 


*2. Compare the educational attainment of African Americans to white respondents.
graph bar (count), over(is_aframerican) by (edu_level)


*3. Compare the employment rate by sex for African Americans and white respondents.
bysort race sex: sum is_empld

*4. Conditional on working, compare hours worked and its standard deviation by sex for African Americans and whites.
bysort race sex: sum uhrswork if (is_empld ==1)

*5. Conditional on working, compare total income, its standard deviation, and its skewness by education and sex for African Americans and whites.
bysort race sex edu_level: sum inctot if (is_empld ==1), detail

*6. For those with positive wages, compare the wage income, its standard deviation, and its skewness by education and sex for African Americans and whites.
bysort race sex edu_level: sum incwage if (incwage > 0 ), detail

*7. Calculate employment rates by age and sex for African Americans and whites.

* first create a new variable 'age_level' that separates all the different ages into age groups in the range of 5 years

gen age_level = "25-29" if age >= 25 & age <30
replace age_level = "30-34" if age >= 30 & age <35
replace age_level = "35-39" if age >= 30 & age <40
replace age_level = "40-44" if age >= 40 & age <45
replace age_level = "45-49" if age >= 45 & age <50
replace age_level = "50-54" if age >= 50 & age <55
replace age_level = "55-59" if age >= 55 & age <= 59

bysort race sex age_level: sum is_empld


*8. Conditional on working, compare the hours worked by education and sex for African Americans and whites.
bysort race sex edu_level: sum uhrswork if (is_empld ==1)


log close




