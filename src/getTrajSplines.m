% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================
function xSP = getTrajSplines(nlp,x);

xSP = [];
count = 0;
for i=1:nlp.nout
    ni = nlp.ninterv(i);
    ord = nlp.order(i);
    sm = nlp.smoothness(i);
    ncoef = ni*(ord-sm) + sm;
    X = x((count+1):(ncoef+count));
    knots = linspace(0,nlp.HL,ni+1);
    augknots=augknt(knots,ord,ord-sm);
    xSP{i} = spmak(augknots,X');
    count = count + ncoef;
end
    
    
    