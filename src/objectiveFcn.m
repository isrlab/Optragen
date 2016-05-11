% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function obj = objectiveFcn(x,knots,sp,t)

sp1 = spmak(knots,x);

f1 = spval(sp1,t);
f2 = spval(sp,t);
obj = norm(f1-f2,2)^2;



