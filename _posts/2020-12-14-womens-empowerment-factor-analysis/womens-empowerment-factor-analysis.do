*Stata code for IPUMS blog post:
*Locating Dimensions of Women's Empoerwment in Family Planning in Burkina Faso

*Recoding FPDECIDER, DECNOFPUSE

tab fpdecider

recode fpdecider (1=3)(2=1)(3=2)(95=.)(96=.)(98=.)(99=.)(9=1), generate (rfpdecider)

label define rfpdecider 1 "woman has no say" 2 "woman has some say" 3 "woman has full say"

label values rfpdecider rfpdecider

numlabel _all, add force

codebook fpdecider

tab rfpdecider

 

tab decnofpuse

recode decnofpuse (1=3)(2=1)(3=2)(95=.)(96=.)(98=.)(99=.)(94=1), generate (rdecnofpuse)

label define rdecnofpuse 1 "woman has no say" 2 "woman has some say" 3 "woman has full say"

label values rdecnofpuse rdecnofpuse

numlabel _all, add force

codebook decnofpuse

tab rdecnofpuse

 

*Creating DECIDER

gen decider = rfpdecider

replace decider = rdecnofpuse if decider ==.

label define decider 1 "woman has no say" 2 "woman has some say" 3 "woman has full say"

label values decider decider

numlabel _all, add force

tab decider

tab rfpdecider decider

tab rdecnofpuse decider

 

*Running weighted polychoric factor analysis

global xlist urban wealthq educattgen fpcurrecuser decider safedisckid safediscfp conflictfp damrelfp negotiatekids beliefcarrypreg beliefdaupreg agreespace agreelimit agreecontr agreefp agreepartfp fpradiohr fptvhr

polychoric $xlist [fweight=fqweight]

display r(sum_w)

global N = r(sum_w)

matrix r = r(R)

factormat r, n($N)

screeplot, yline(1)

factormat r, n($N) factors(3)

 

*Running rotations and suppressing loadings <0.3 to ease interpretation

rotate, promax blanks(.3)

rotate, clear

rotate, varimax blanks(.3)

rotate, clear

 

*Running estat kmo to check that factor analysis was appropriate for these variables

estat kmo
