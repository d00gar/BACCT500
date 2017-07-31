version 13.1
set more off
capture log close
log using Stat1.log, t replace

* Lesson 1
* Refresh recall of key concepts:
*  - observations, data, population, sample, variable, statistic
*  - distributions and associated terms: 
*	 > frequency,  density, cumulatives
*	 > location, dispersion, asymmetry (skewness), peakedness
*	 > moments, cumulants 

*   In this exercise you will be asked to run one or more lines of code, examine
* screen output and the underlying data and answer some simple questions before 
* moving on to the next part.  Parts are serially numbered to make it easier for
* you to keep track of your progress. 
*   As you run the code, it may be a good idea to record your answers in the .do
* file itself, below each question.  If you comment out the answers properly, at
* the end of the exercise, you should be able to run the entire program and your
* log file will record both the screen output and your answers.
*  To submit your homework, upload both the .do and the .log file.  Before you 
* upload the files on canvas make sure your name appears in the line below:

*  Student name:          Master Accountant
*  UW netid:              acct007@uw.edu 

   * ======================                         ====================== *
  * ====================== PREFACE -- READ CAREFULLY ====================== *
   * ======================                         ====================== *
*
*  As discussed in the introduction to Stata session, the reason we use Stata in
* this course is that it has a rich set of packaged routines that serve most if
* not all of the data analysis needs for statisticians and accountants.  This 
* allows us to focus on using "standard" tools to reach our ends, decreasing the
* chance that we have made a subtle error somewhere in our thinking.  Another 
* key advantage that makes Stata attractive is that it is interactive: one runs
* a command and sees the output almost immediately and the data are available 
* at any time for browsing so that one can also see exactly how the command has 
* affected that data organization.  Collectively, these two aspects of Stata are
* enormously effective for developing a deep understanding of the data, without 
* which effective analysis is impossible.  
* 
*  Like any general purpose statistical program Stata, as a whole, is a massive, 
* sprawling and complex edifice.  We will use only the most basic commands and 
* perform relatively simple tasks.  Even these can be accmplished in more than
* one way and with many options.  As a result Stata is customizable to a depth
* that is difficult to convey in this introductory note.  The price of access to
* this power, is dogged patience to master the syntax, the self-discipline to 
* accept almost continuous feedback on inadequacies in one's own thinking and
* understanding of the data, of statistics or of Stata itself. Be ready to
* invest to "buy and hold," rather than to "cut and run on the dip."  In three 
* weeks, you will be able to surprise yourself with what you can do. :)
*
* For every command you use, read the help file (type "h commandname" without
* quotes at the Stata command prompt and the help documentation will open up in
* a separate window.  Embedded therein you will find links to more-extensive pdf
* documentation as well.  Read both carefully.  For yet more information, search 
* Statalist, YouTube or the web: any questions you have most likely will have 
* been already raised and addressed in a way that will not only resolve your
* immediate query but improve you thinking about your data and its management.
* A good, even excellent, thought to keep in mind is that if your question does
* not seem to be addressed, you probably are asking the wrong question.  Reframe 
* it somewhat differently and ask again.  After about three tries you will find 
* the magic post/video/page ... if you don't let me know. 

*   If you have ever searched any accounting, legal or tax codification, this 
*   iterative and sometimes lengthy research process should be familiar, so 
*   rememebr to be patient with yourself. And, if you are yet to experience the 
*   joys of searching FARS or RIA or Lexis-Nexis, be happy that Stata is far
*   more structured and easy to research.  Guaranteed. :) 
*    
*   Some advice regarding Statalist
*    Statalist is designed to help users resolve problems that they have tried 
*    but are unable to resolve on their own or by resorting to the sneaker-net.
*    That would be you at your day job in an organization where nobody knows
*    Stata and after you've spent some real effort reading the manuals and 
*    trying out several alternatives.
*
*    Statalist is not meant to - and should not be used to - get help for course
*    or homework related problems or to get someone else to do your thinking for
*    you.  Please do not use it that way!
*
*   How to get the help you need
*    When - note the when, not if - you run into problems w/any homework or data
*    exercise, I expect you to:
*     1. write out as precisely as you can what you are trying to do using
*        a numerical example (Hint: think carefully about what you are trying
*        to do to, or with, your data array.),
*     2. provide your sample code with an explanation of what each step is
*        intended to accomplish,
*     3. read and re-read (twice at least) the help and pdf files,
*     4. search for a solution on the web: including Stata in the search term
*        usually leads to a pretty good starting point (Don't worry about 
*        looking for the right stata terminology in your query, natural
*        language queries work almost as well.),
*     5. Contact the TA with the details of your steps 1-4.  If the TA does 
*        not know or is out of bandwidth, they have insturctions to let you
*        know and bump the cue to me,
*     6. If you have not heard from the TA in 24 hours, escalate to me.  
*
   * ======================                         ====================== *
  * ======================        END PREFACE        ====================== *
   * ======================                         ====================== *

* ----------------------------------------------------------------------------
* |><|><|><}><|><|><|><|><}><|><|><|><|><}><|><|><|><|><|><|><}><|><|><|><|><|
*
*                                 Some definitions                         <*>
*
* |><|><|><}><|><|><|><|><}><|><|><|><|><}><|><|><|><|><|><|><}><|><|><|><|><|
* ----------------------------------------------------------------------------
* data: a collective noun that refers to a set of one or more
*        "observations" on one or more "variables"
* observations have "numbers" ... "the first observation", 
*	 "obs number 7", "obs # 186547" etc.
* variables have "values" ... "in obs # 25, variable x1 has the value 7.34"
* population: all the data that can possibly exist: "the population of all
*             public companies in the US during the period 1933-2017." 
* sample: subset of the population for which we have - possibly noisy - data 
* statistic: some defined property of the data
* ----------------------------------------------------------------------------
* |><|><|><}><|><|><|><|><}><|><|><|><|><}><|><|><|><|><|><|><}><|><|><|><|><|
* ----------------------------------------------------------------------------

*                  -- Let's get started with some basics --                   

* 1.1  Visualize an empty data set, then execute the next line
br
 
*  --  OK, that was easy ... a bit too easy, perhaps.  What next?  --                   

* 1.2 Let's use some data provided to us
use dataset1, clear

* 1.3.1 Browse the data then complete exercise 1.3.1 below 
br
*
* Exercise 1.3.1
* What key properties of the data are evident from browsing?
*  o how many observations are there?  how many variables?
*  o what is the data about?  what do the variables represent? can you tell?
*  o What else you can say about the data as a whole?
*  o What can you say about the variables individually or as a group?
*
*          --- TYPE YOUR ANSWERS BELOW, ADDING NEW LINES AS NEEDED ---
*


* -- That was easy, but made me think a bit ... I'm ready for more --

* 1.3.2 Describe the data and complete exercise 1.3.2 below
describe
*
* Exercise 1.3.2
*  What additional information did "describe" provide?
*

* -- Got it, let's move on ...

* 1.3.3 Summarize the data and complete exercise 1.3.3 below
summarize

*
* Exercise 1.3.3
*  What additional information did "summarize" provide?
*

* -- Got that too ... next step please ...

* 1.3.4 Inspect the data and complete exercise 1.3.4 below
inspect
*
* Exercise 1.3.4
*  What additional information did "inspect" provide?
*   In answering this question, it may help to first read the help file
*   on the - inspect - command, type "h inspect" (without the qoutes)
*   at the command prompt.  You may also want to read the associated pdf 
*   documentation and review the associated Stata YouTube video.
*

* -- Anything else?

* 1.3.5 Examine the data codebook and complete exercise 1.3.5 below
codebook
*
* Exercise 1.3.5
*  What additional information did "codebook" provide?
*   As before, feel free to do some reading before answering the question ...
*

* -- Summarize was nice, but I want a bit more detail on the variables

* 1.3.6 Glad you asked!  Run line 97 and complete Ex 1.3.6 below
su, det           // note the contraction in syntax for "summarize, detail"
*
* Exercise 1.3.6
*  What does the additional output of the "detail" option tell you?
*   o focus on one to three typical variables
*   o for each variable visualize what each statistic reported "tells" you
*   o for each variable, what does the ensemble of statistics tell you?
*     Again, feel free to read the help/pdf documentation and review the YouTube
*     video: https://www.youtube.com/watch?v=kKFbnEWwa2s
*

*  Enough numbers for now, let's see some pictures: seeing is believing

* 1.4 Plotting the data
* lets do a scatter plot.  the following code is typical and self-explanatory
*  but after completing this exercise, you should spend some time reading up 
*  the related parts of the manual carefully to learn how powerful stata 
*  graphing can be. type "help scatter" or "h scatter" for more information.
*  Also look up video expositions on scatter on YouTube.

* run the following command to get started with graphing 
graph twoway scatter v1 v0, saving(scatter_v1_v0, replace) 
*
* Note that variable names and tick marks on both axes are default options.  
* You can turn them off or turn on many other options as shown next.
*

* now try the following command (Note that the "///" line continuation
*  command allows us to keep typing a long command across multiple lines
*  making it easier to see what the command does.) 
sc v1 v0, msize(small) mcolor(red) ///
   title("Scatter of v1 against v0" "A generic dataset")  ///
   saving(scatter_v1_v0, replace)
* 
* Note that we can used just "sc" to invoke "graph twoway scatter" -- saves
*  typing and - for the most part - is far less taxing to read.
*
* Graphing is one of the most important tools a data analyst must master
* so it will repay you amply to read - and keep re-reading - the stata help
* and pdf documentation on graph.  
*

* Exercise 1.4
* plot v3 and v6 and v9 against v0 and interpret each graph
* create a command to plot v3 vs. v0 in the space below and run it

* interpret the picture you created (use <=50 words)
*
*
*
*

* create a command to plot v6 vs. v0 in the space below and run it
* in your command change one option ... try to use a different markersymbol

* interpret the picture you just created (use <=50 words)
*
*
*
*

* create a command to plot v9 vs. v0 in the space below, use two more options 
* that you think improve the graph

* interpret the new picture (use <=50 words)
*
*
*
*

* 1.5 plot simultaneously any two of the variables v1-v10 against v0

* interpret this picture (use <=50 words)
*
*
*
*

* try the following command
line v1 v0, lcolor(red) lpattern(l) lwidth(medium)            ///
     title("Line plot of v1 against v0" "A generic dataset")  ///
     saving(line_v1_v0, replace)

* and now try
line v1 v0, lcolor(red) lpattern(l) lwidth(medium) ||          ///
 sc  v1 v0, mcolor(blue) msymbol(+) msize(small)               ///
      legend(off)                                              ///
      title("Line plot of v1 against v0" "A generic dataset")  ///
      saving(linescatter_v1_v0, replace)

* create a line-scatter graph of v10 against v3, making two improvements
* of your choice to the generic graph command above.

*  Exercise 1.5  Select two variables to plot against a third variable
*   using some combination of line and scatter and describe briefly
*   how the picture you have drawn relates to the information about 
*   those two variables provided by the summarize, detail command
*    Hint: this exercise requires you to think carefully about the choice of 
*          variable to use as the x-axis (the "against" variable)
*

* Self-evaluation:  Was your answer, roughly speaking as follows?
*   OK, I get it! plotting any variable against v0 (the observation number)
*   is a quick way to see all values of the variable, I can then link individual
*   values to the statistics reported by summarize, detail.  
* If it was, you're doing well.

* In fact, this picture is very powerful tool for understanding our data.  It
*  allows "read off" the number of occurances of any value of the y-variable by
*  drawing a line parallel to the x-axis for any value of y. All points on such
*  a line are called the "level set of y" at that value. If y never takes that
*  value, the level set will be empty. If y takes the value once, twice, three
*  times etc., the line will intersect the graph once, twice, thrice etc.. If
*  all values of y are the same they will fall on one such line and if y takes
*  a finite number of values, only as many of its level sets will be non-empty.
*
*   Thinking in terms of level sets of a variable is a very powerful way
*   to understand your data.  Even if it is not intuitive at first, you should
*   persevere.  The rewards of finally "getting it" are unparalled. :)

* It is quite instructive to extend the graph you drew to make this linkage 
*  explicit. For a plot of v7 and v10 against v0, this can be done as follows.

 // we first summarize the variable and store values of some key statsitics
 //  of its distribution as local macros.  These values will be our target
 //  level sets.  Note that the code gets a bit fancy by taking the integer 
 // portion of each statistic rounded to zero decimal places.  This is overkill
 // but is a good way to demonstrate the range of possibilities open to you.
qui su v7, det
local mi7  = int(round(r(min),1))
local ma7  = int(round(r(max),1))
local mu7  = int(round(r(mean),1))
local fq7  = int(round(r(p25),1))
local me7  = int(round(r(p50),1))
local tq7  = int(round(r(p75),1))
qui su v10, det
local mi10 = int(round(r(min),1))
local ma10 = int(round(r(max),1))
local mu10 = int(round(r(mean),1))
local fq10 = int(round(r(p25),1))
local me10 = int(round(r(p50),1))
local tq10 = int(round(r(p75),1))

 // we print out the values of the locals ... if the code crashes, reviewing 
 // this line will tell us if the error lies in how we coded the locals ...
di `"`mi7' `mu7' `fq7' `me7' `tq7' `ma7' || `mi7' `mu10' `fq10' `me10' `tq10' `ma7'"'

 // now to use the values stored in the locals as level sets, we simply add
 // a yline (look up added_line_options) at the value of the relevant local.
 //  Again, we get a bit fancy with changing linepatterns and linecolors, but
 //  all in the cause of a good graduate tutorial.

* set more off
* set trace on
line v7  v0, lcolor(red) lpattern(l) lwidth(medium) ||                  ///
line v10 v0, lcolor(blue) lpattern(l) lwidth(thin)  ||                  ///
 sc  v7  v0, mcolor(blue) msymbol(+) msize(small)   ||                  ///
 sc  v10 v0, mcolor(red)  msymbol(d) msize(small)                       ///
     legend(off)                                                        ///
	 yli(`mu7', lp(l) lc(blue)) yli(`me7', lp(dash) lc(blue))           ///
	 yli(`mi7'  `fq7'  `tq7'  `ma7', lp(dot) lcolor(blue))              ///
	 yli(`mu10', lp(l) lc(green)) yli(`me10', lp(dash) lc(green))       ///
	 yli(`mi10' `fq10' `tq10' `ma10', lp(dot) lc(green))                ///
     title("Line plot of v7 and v10 against v0" "A generic dataset")    ///
     saving(linescatter_v7v10_v0, replace)
set trace off 
set more on

/* Exercise 1.Final  A final reflection exercise for today.
    As you look back at what you've done, did you ever tell yourself "This is
     not accounting!"?  It sure isn't anything like what we normally learn or
     use in accounting classes or use in doing day-to-day accounting.  So why
     drag us through all this review of stuff we will never use in our 
     professional lives?
    If you did, you are not alone.  This is a very normal question to ask. 
     The answer is obvious, but discovering it for yourself and stating it in 
     your own words is likely to be more productive in the long run. One way 
     to do this is to set out in 50-75 words your views on the proposition:
       Any accountant who fails to see that accounting is a branch of 
	   applied statistics does not truly understand what accounting does,
	   how accounting data is produced or the nature and properties of 
	   accounting data.  Such a person does not understand accounting!    */
*               - Provide your answer below, adding lines as needed -
*
*	   
*
*
*

* Last step
* Save this do file, run it start to finish and upload it and the log file
*  to Canvas.  Do not work on the code below till you have uploaded.

*   -------------            Begin stretch exercise             -------------
*********                                                              *********
******                           FOR AFTERHOURS                           ******
***            Warning:  Not for the faint of heart or the pain-averse.      ***
******                                                                    ******
*  Note 1:  If you want to hack this, you have found your true home.  Welcome!
*  Note 2:  If you don't want to hack it, ignore it for now.  We'll do it less
*            far less painfully later.  But you'll have to wait and we may not
*            get there for a while and in as much detail.
******                                                                    ******
*  Parse and understand the following code, then uncomment and run it.
/*
foreach t of var v1-v9 {
qui su `t', det
local mit  = int(round(r(min),1))
local mat  = int(round(r(max),1))
local mut  = int(round(r(mean),1))
local fqt  = int(round(r(p25),1))
local met  = int(round(r(p50),1))
local tqt  = int(round(r(p75),1))
qui su v10, det
local mi10 = int(round(r(min),1))
local ma10 = int(round(r(max),1))
local mu10 = int(round(r(mean),1))
local fq10 = int(round(r(p25),1))
local me10 = int(round(r(p50),1))
local tq10 = int(round(r(p75),1))							
line `t' v0, lcolor(red) lpattern(l) lwidth(medium) ||                  ///
line v10 v0, lcolor(blue) lpattern(l) lwidth(thin)  ||                  ///
 sc  `t' v0, mcolor(blue) msymbol(+) msize(small)   ||                  ///
 sc  v10 v0, mcolor(red)  msymbol(d) msize(small)                       ///
     legend(off)                                                        ///
	 yli(`mut', lp(l) lc(blue)) yli(`met', lp(dash) lc(blue))           ///
	 yli(`mit'  `fqt'  `tqt'  `mat', lp(dot) lcolor(blue))              ///
	 yli(`mu10', lp(l) lc(green)) yli(`me10', lp(dash) lc(green))       ///
	 yli(`mi10' `fq10' `tq10' `ma10', lp(dot) lc(green))                ///
     title("Line plot of `t' and v10 against v0" "A generic dataset")   ///
     saving(linescatter_`t'v10_v0, replace)
	                   }
*/

* When you get it, go out and celebrate.  The ability to effortlessly (!) unlock
*  the secrets of accounting data is now at your fingertips.

*   -------------             End stretch exercise             -------------

* exit nicely
log close
exit

* ==========================================================
*                           Code locker
* ----------------------------------------------------------
* Topics left for future lessons:
 -- deeper dive into random variables
 -- generating rvs
 -- model identification
 -- hypothesis testing
 -- prediction

/*


* set trace on
foreach v of varlist v1-v10 {
su `v', det
sc `v' v0, saving(`v'_sc, replace)
line `v' v0, saving(`v'_li, replace)
hist `v', saving(`v'_hist, replace)
                            }
foreach v of var v1-v9 {
qui su `v', det
local mit  = int(round(r(min),1))
local mat  = int(round(r(max),1))
local mut  = int(round(r(mean),1))
local fqt  = int(round(r(p25),1))
local met  = int(round(r(p50),1))
local tqt  = int(round(r(p75),1))
qui su v10, det
local mi10 = int(round(r(min),1))
local ma10 = int(round(r(max),1))
local mu10 = int(round(r(mean),1))
local fq10 = int(round(r(p25),1))
local me10 = int(round(r(p50),1))
local tq10 = int(round(r(p75),1))							
line `v' v0, lcolor(red) lpattern(l) lwidth(medium) ||                  ///
line v10 v0, lcolor(blue) lpattern(l) lwidth(thin)  ||                  ///
 sc  `v' v0, mcolor(blue) msymbol(+) msize(small)   ||                  ///
 sc  v10 v0, mcolor(red)  msymbol(d) msize(small)                       ///
     legend(off)                                                        ///
	 yli(`mut', lp(l) lc(blue)) yli(`met', lp(dash) lc(blue))   ///
	 yli(`mit'  `fqt'  `tqt'  `mat', lp(dot) lcolor(blue))              ///
	 yli(`mu10', lp(l) lc(green)) yli(`me10', lp(dash) lc(green))       ///
	 yli(`mi10' `fq10' `tq10' `ma10', lp(dot) lc(green))                ///
     title("Line plot of `v1' and v10 against v0" "A generic dataset")    ///
     saving(linescatter_`v1'v10_v0, replace)
	 }
	 
* set trace off
foreach v of varlist v1-v10 {
foreach w of varlist v1-v10 {
line `v' `w', saving(`v'_`w'_li, replace)
}
}
*

* ----------------------------------------------------
* |><|><|><}><|><|><|><|><}><|><|><|><|><}><|><|><|><|
* ----------------------------------------------------

* ----------------------------------------------------
* |<.>|<.>|<.>| * |<.>|<*>|00|<*>|<.>| * |<.>|<.>|<.>|
* ----------------------------------------------------
