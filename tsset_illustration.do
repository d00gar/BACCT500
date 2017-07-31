version 13.1
set more off
capture log close
log using tsset_illustration.log, t replace
clear
set obs 6
input sid qid gpa
1 1 3.4
1 3 3.5
2 2 3.3
1 2 3.2
2 3 3.4
3 4 3.6
li
la var sid "student id"
la var qid "quarter id"
la var gpa "grade point average"

* demonstrate [_n-1] and [_n+1] operation
g lgpa = gpa[_n-1]
g fgpa = gpa[_n+1]
* demonstrate by
capture by sid: g lgpa2=gpa[_n-1]
*
* This command fails.  Why?  Stata starts with sort order being blank.
*  We have thus far not told stata the sort order.
*

* preserve and li noting the sort order
preserve
li
* try something different using bys (by + sort)
bys sid: g lgpa2=gpa[_n-1]  
bys sid: g fgpa2=gpa[_n+1]
 *
 * this runs .. try and understand what it produces, then li
 *  note the sort order change due to the bys command
li
 
 * now try
 restore
* restoring the data restores the sort order before last bys
*  check by listing the data!
li                  
 * now try the following
 sort sid qid                     // sort by both sid and qid
 bys sid: g lgpa3=gpa[_n-1]       // then generate within sid
 bys sid: g fgpa3=gpa[_n+1]       // then generate within sid
* and then
capture bys sid: g lgpa4=l.gpa       // then generate within sid
capture bys sid: g fgpa4=f.gpa       // then generate within sid
* this failed because we did not tssset
* try tsset timevar only
capture tsset qid
*
* This did not run because of repreated time values
* so now try to also specify panelvar ... no duplicate qid per student
tsset sid qid
* now try
capture g lgpa4=l.gpa
capture g fgpa4=f.gpa
*
* still did not run, data not sorted
*  ... note that specifying tsset does not auotmatically sort the data by
*      panelid timevar
sort sid qid
capture g lgpa4=l.gpa
capture g fgpa4=f.gpa
* 
* now evertyhing runs.  browse the data one more time to compare the 
*  effects of the different ways of coding leads and lag
li

* exit nicely
log close
exit


* ==============================================================================
*                     Code locker ... old and unused code ....
* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/* commands from 20170724 session with Xian (UWBB104 F, 3:45-5:15 pm)
use "C:\Users\doogar\Google Drive\Data\Teach\BBUS 600 Independent Study\Xian\test1.dta" 
tsset
h tsset
tsset, clear
tsset
sort sid qid
g lgpa=l.gpa
tsset qid
g lgpa=l.gpa
tsset sid qid
sort sid qid
g lgpa2=l.gpa
sort gpa
g lgpa3=l.gpa
sort sid quid
sort sid qid
drop lg*
by sid: g ligpa=gpa if _n==1
replace ligpa=gpa+l.gpa if _n==2
drop lgpa
drop ligpa
by sid: g ligpa=gpa if _n==1
replace ligpa=gpa+l.gpa if _n>1
drop ligpa
by sid: g ligpa=gpa if _n==1
by sid: replace ligpa=gpa+l.gpa if _n>1
g ligpa2=gpa+l.gpa
drop ligpa2
g ligpa=gpa
g ligpa2=gpa
replace ligpa2=l.ligpa2+gpa if l.ligpa!=.
h egen
