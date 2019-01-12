

k=qpar('k',2,2,5,8);
a=qpar('a',3,1,3,8);
z=qpar('z',0.6,0.3,0.6,8);
wn=qpar('wn',4,4,8,8);

num = [k*wn*wn k*wn*wn*a];
den = [1 2*z*wn wn*wn];
P = qplant(num,den)

w = [0.2 0.5 1 2 5 10 20 50];
%cgrid(P,w,0)
tic
ctpl(P,'grid',w)
toc
cnom(P,logspace(-2,2,200));

t1=P.templates(1);
ta=P.templates;
return
%%
tic
P.ctpl('aedgrid',w)
toc
%%
tic
ctpl('ex1',[],'aedgrid');
toc
%showtpl('ex1',5)