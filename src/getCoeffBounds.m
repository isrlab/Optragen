function [xlow,xup] = getCoeffBounds(nlp,XLOW,XUP)


xlow = [];
xup = [];

if (numel(XLOW) ~= nlp.nout || numel(XUP) ~= nlp.nout)
    error('XLOW, XUPP must be of dimension nlp.nout');
end

for i=1:nlp.nout
    n = nlp.ninterv(i);
    s = nlp.smoothness(i);
    r = nlp.order(i);
    ncoeff = n*(r-s) +s;
    xlow = [xlow;ones(ncoeff,1)*XLOW(i)];
    xup = [xup;ones(ncoeff,1)*XUP(i)];
end

