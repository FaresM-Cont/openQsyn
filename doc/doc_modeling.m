%% Modeling of uncertain plants
%% Overview 
% The first stage in QFT design is to define the uncertain plant. 
% *Open Qsyn* facilitates plant modeling using these classes:
%
% * <matlab:doc('qpar') qpar> describes a single uncertain parameter
% * <matlab:doc('qexpression') qexpression> describes an aritmatic expression composed of one or more qpar elements 
% * <matlab:doc('qpoly') qpoly>  describes an uncertain polynom --composed of qpars and qexpressions 
% * <matlab:doc('qplant') qplant> describes an uncertain plant

%%
% Note that this page describes plant modeling as a set of LTI tranfer functions.
% *Open Qsyn* also allows for "black box" plants and 
% for plants described as measured frequecy response data. 
% See <matlab:web('ex_blackBox.html') Black Box Example> and 
% <matlab:web('ex_qmeas.html') Data Based Design Example>, respectively. 

%%
% In addition, plants that are given in Real Factored Form can also (should!) be 
% consturcted differently, in a way that expolites their unique structure,
% see <matlab:web('ex_rff.html') RFF Example>.

%% Modeling uncertain parameters
% Uncertain parameters are modeled using <matlab:doc('qpar') qpar> objects. 
% a <matlab:doc('qpar') qpar> object is constructed as follows
%
%   a = qpar(name,nominal_val,lower_bound,upper_bound,cases)
%
% where name is a string; nominal_val, lower_bound, upper_bound are scalar
% numbers describing the nominl value, lower bound, and upper bound, respectively; 
% cases is an optional input agrument which specifies the number of uncertain 
% cases, i.e. the number of grid points.

%%
% *Exmaple*: constarct an uncertain parameter $a \in [0,2]$ with nominal 
% value 1. 
a = qpar('A',1,0,2)
%%
% as 'cases' was not specified, the qpar element is crearted with the 
% default value of cases, which is 3. 
% Note also that the name, in this exmaple |A|, may be different from the parameter in which 
% the element is stored, in this exmaple |a|.
%
% One can add a description to a parameter by utilizing the |description| 
% property, for e.g. 
a.description = 'an exmaple parameter';

%%
% Elements of qpar class can be grouped into qpar array by *vertical* concatenation.
% Hence, qpar array are all column vectors. Horizontal concatenation serves
% a specific role which will be discussed later. 
%
% *Example*: crate a qpar array 
b = qpar('B',0.2,0.1,0.2,4);
parArray = [a ; b]
%%
% One can generate random smaples of a qpar object or array using |sample()|,
% or generate a grid using |grid()|. These functions produces values which
% are in the uncertanty range of tha pearmeter(s).
asmap = sample(a,5)
absamp = sample(parArray,5)
pargrid = grid(parArray)
%%
% Note that |sample| and |gird| are *methods* of the |qexpression| class. 
% Class methods are functions which can take class objects as inputs. To 
% list all methods of a specific object type |methods(object)|:
methods(a)
%%
% T oget help on a specific function type |help object.method|, or 
% |help object/method|.
help a.ismember
%% Creating uncertain arithmetic expressions
% |qpar|  elements can be combined with other |qpar| elements and
% numericals to create uncertain arithmetic expressions. Allowed arithmetic
% expressions are |+|, |-|, |*|, |/|.
%
% *Exmaple*:
ab = a*b 
%%
% the |*| opetation created a <matlab:doc('qexpression') qexpression>  elements. 
% A qexpression stores the parametric description along with a list of all 
% envolded qpar objects in a qpar array. 
%
% To accsess the array use |qexpression.pars|. For exmaple:
ab.pars(1)
%%
% Alternatively, a |qexpression| can be generated explicity using the
% syntex |expr = qexpression(A,B,operation)|. Hence the following is
% identical to the previous example
ab2 = qexpression(a,b,'*')
%%
% One can compute the qexpression values at different parameter cases using
% |cases()|, which by default compute values on a uniform grid of the
% parameters space, with number of grid points defined by the |cases|
% property in each |qpar|. 
cases(ab)

%% Creating an uncertain polynomial 
% An uncertain polinomial is represented by a <matlab:doc('qpoly') qpoly>
% object. Each coefficient in such polynomial is either a |qpar|, a
% |qexpression|, or a real scalar. 
% A |qexpression| is generated by horizolnal concatenation of elements
p1 = [1 a]
%%
% Alternatively, it can be generated explicitly using the syntex
% |p = qpoly(an,...,a1,a0)|. Hence the following is
% identical to the previous example
p2 = qpoly(1,a)
%%
% Again, values at different parameter cases are computed using |cases()|. 
% To retrive the coefficients, one can use the method |coeffs()|
[a1,a0]=coeffs(p1)

%% Creating the plant
% Finally, an uncertaon plant, or <matlab:doc('qplant') qplant>, is
% generated by 
%
%   P = qplant(num,den)
%
% with num,den two qpoly objects which represents the plant transfer function
% numerator and denumerator. 

%%
% *Example*: create the plant 
%
% $$ P(s) = \frac{s+a}{s+b}, ~~ a \in [0,2], ~~ b \in [0.1,0.2]$$ 
% 
num = [1 a];
den = [1 b];
P = qplant(num,den)
%%
% The plant |P| is a |qplant| objects which includes the num,den qpoly
% object as properties, as well as a |pars| property which stores the qpar
% array of qpar objects in both qpolys. 
%
% A plant object allows for time as well a frequency domain simulations
% with the methods such as |step|, |niccases|, and |bodcases| (stands for 
% Nichols-cases and Bode-cases, respectively). For example, a Bode plot of
% a uniform grid of 8 points for each parametr is done by
pargrid=grid(P.pars,8);
bodcases(P,pargrid)

%%
% This is the time to move forward to 
% <matlab:web('doc_ctpl.html') Step 2: Template Computation>  
