version 13.1
set more off 
log using prob1.log, t replace

* This lesson revisits probability notions most germane to data analysts.   
*
* The field of probability studies the flavors of chance.  In this module we  
* examine some of the basic ideas of "chance" "experiment," "event," and link
* link them to numerical measures such as "frequency" and "probability."  This
* should give you a sense for the probability "model" that underlies much of
* modern statistical thinking as well as decision making under uncertainty.

*  1. Consider the chance of 
*    (a) a "fair coin" coming up heads
*    (b) drawing a black ball from a basket of 100 balls, 50 black, rest white
*    (c) drawing a black ball from a basket of 100 balls, 90 black, rest white
*    (d) drawing a black ball from a basket of 100 balls, 10 black, rest white
*    (e) drawing three black balls in five draws from a basket of 100 balls
*        (1) 50 black, rest white 
*        (2) 90 black, rest white 
*        (3) 10 black, rest white 

*  Tasks:
*  Task 1:  In the space below, adding extra new lines as needed, describe in 
*   words the chance of 1(a) through 1(d).  In each case, after providing a 
*   description of the chance, provide a numerical measure of the chance. In
*   each case limit your verbal answer to 10 words or so.











* Task 2: How is 1(e) different from the pervious cases?  what new factors, if
*  any, must now be taken into account? (Limit your answer to no more than 50
*  words and identify only the most important differences).





* In responding to tasks 1 and 2 the following ideas may have come to mind:
*
*  > The process of tossing the coin or drawing a ball is called an experiment. 
*
*  > The experimental outcome: heads, black ball etc., is called an event.
*
*  > In cases 1(a) through 1(d), the general idea is that the coin will be
*     tossed once, or one ball will be drawn and the outcome noted.  Case 1(e)
*     however is different and more complex ... one has to imagine five draws
*     one after the other producing in total three black balls and two white
*     balls (with no "draw" coming up empty handed or with a red or blue or
*     yellow or green ball or an orange square ... in other words, notice that
*     we are all of sudden thinking in a very highly structured way: every
*     possible nuance than makes "real life" so much more complicated is being
*     sytematically removed from consideration: in this way of thinking only
*     certain things can happen, and nothing else.  A drawing of a ball from
*     a basket with 100 balls, 50 black and rest white will always result in
*     either a black or a white ball being drawn, a single ball being drawn (no
*     bank draws) and the ball drawn will be either black or white (nobdy will
*     have played the practical joke on us of adding two back-and-white balls).
*  
*   > Such abstraction makes the study of a probability a theoretical discipline
*     and applying the results of the theoretical analysis to real life requires
*     careful thought and caution because in reality, the contents of the basket
*     may be changing over time: if this is a basket of balls in the locker room 
*     of a sports club, balls will be added or removed as players start or
*     finish their matches and the colors of balls may be yellow and green. One
*     of these differences ("violations of model assumptions" will be important 
*     for our purposes, the other not (Can you guess which is which?).  
  
*   As you will have realized cases 1(a) and 1(b) are in some sense identical:
*  tossing a fair coin once is not that different from randomly drawing one ball
*  from a basket containing equal numbers of black and white balls. The other
*  two cases, 1(c) and 1(d) are somewhat different: a random draw is much more
*  likely to produce a black ball (case 1(c)) or a white ball (case 1(d)). Case
*  1(e) on the other hand consists of a more-complex experiment an raises all
*  kinds of new problems: we now have to conduct a "compound" experiment which
*  requires us to draw five balls and come up with three black (and two white)
*  balls.  Do we draw the balls all at once?  One after the other?  Does it make
*  a difference?  Why or why not?  How would we know if it makes a difference?
*  These are the kinds of questions the field of probability investigates.

* Answering them leads to some very interesting insights, so let us take a 
* closer look at a simpler problem than 1(e).   
*  What if we toss the coin a second time or draw a second ball from the basket?  

* In the case of the coin toss, things are simple: it is quite easy to see that
* a second coin toss will be exactly like the first.  Nothing about the coin 
* changes between tosses: it is the same thing all over again, or to put it  
* formally, the underlying outcome generating process is time-invariant.

* In case of the ball drawing, however, things are different: if the first ball
* is replaced back in the basket before the second ball is drawn, the second
* draw will be exactly like the first.  If, however the first ball is not
* replaced in basket before the second draw, the basket would only contain 99 
* balls, with 49 balls of one color and 50 balls of the other color. As you can
* imagine, this experiment is not the same as the experiment of drawing a ball
* from a basket with 50 black and 50 white balls.  It is therefore vital to know
* if the draws are conducted with replacement or without.  This kind of detail
* is characteristic of the study of probability and makes it both subtle and 
* challenging.  "Do we have the right probability model?" is a persistent 
* question to which the analyst almost never has a fully satisfactory answer. 

*  Also notice that the general idea is that the experimenter does  not control
*  the outcome: a fair coin, by definition, is one that is as likely to come up
*  heads or tails and the process of drawing a ball assumed - even though I did
*  not explicitly state it as part of the experimental specification - that the 
*  balls are drawn at random.  This is an important caveat to check ... if the
*  coin is not fair, then either heads or tails will have a greater chance of
*  coming up on any given toss and if the experimenter can look into the urn and
*  select the color of the ball, she can choose any color she likes.  In both
*  cases, the chance of heads coming up or a black ball being drawn will be
*  different from the chance of the event occurring is the outcome is randomly
*  determined.  

*  In sum, when computing probabilities, one must know at least two types of
*  details: is the outcome generating process random and is it time-invariant?
*  For simplicity, in this review, we will assume the answers are yes, and, no.
*  In other words, we will examine random processes that may or may not be time
*  invariant, so we need to be careful in reading and formulating the model.

* Returning to the second experiment, we therefore have for the coin toss
* > the probability of heads coming up when one fair coin is tossed once is
*   one half, or, writing it more compactly, B(1,1) = 0.5,
* > the probability of heads coming up in the second toss, is B(1,1) as well.

* This example is foundational and worthy of very careful understanding. There 
* are several points worth noting here:
*  > a probabilty measure is strictly positive and always less than 1,
*  > a probability of zero means that even can never occur, ever,
*  > a probability of one  means nothing else ever occurs, never,
*  > if the underlying OGP is perfectly stable, each event is independent of all
*    others meaning that the probability of the outcomes also is time-invariant,

* Now some very interesting possibilities open up.  How many outcomes are there
* of the experiment of tossing a coin twice?  From out study of permutations and
* combinations, we know the outcomes could be (HH), (TH), (HT) and (TT) so that
* the "probability" of two heads coming up in two tosses of the same coin is
* B(1,1)*B(1,1) or 0.25, of two tails coming up is B(0,1)*B(0,1) or 0.25, and 
* the probability of one head and one tail coming up is 
*  B(0,1)*B(1,0) + B(1,0)*B(0,1) = 0.5*0.5 + 0.5*0.5 = 0.5.
* In this example, the set of possible outcomes {(HH), (TH), (HT) and (TT)} is
*  the "sample space," (HH), (TH), (HT) and (TT) are the individual outcomes,
*  making up the entire sample space and the total probability of all events 
*  that make up the entire sample is always 1.  The sample space, in other words
*  is the totality of things that can and do happen and nothing else can happen.

* What would the sample space be if the coin were tossed three times?  If it
* were tossed five times?         

*     
*
*   - drawing more than two black balls in five draws from a basket of 100 balls
*     > 50 black, rest white 
*     > 90 black, rest white 
*     > 10 black, rest white 
*  Consider the number of
*   -  
*    
*  More advanced 
