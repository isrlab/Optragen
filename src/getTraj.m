% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================
function sp = getTraj(optparam,Soln,name);

%optparam = prbInfo.optparam;

ncoef = [];
index = [];
for i=1:optparam.nout 
    ncoef(i) = optparam.ninterv(i)*(optparam.order(i)-optparam.smoothness(i))+optparam.smoothness(i);
    if strcmp(name,optparam.OutputInfo(i).name);
        index = i;
        break;
    end  
end

if isempty(index)
    error('Unknown trajectory specified');
end

b = sum(ncoef);
a = b-ncoef(end)+1;
knots = linspace(0,optparam.HL,optparam.ninterv(index)+1);
augknots=augknt(knots,optparam.order(index),optparam.order(index)-optparam.smoothness(index));
coefs = Soln(a:b);
sp = spmak(augknots,coefs);

